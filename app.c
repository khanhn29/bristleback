#include <mega128.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <delay.h>
#include <ctype.h>
#include "main.h"

unsigned int      g_count_adc_0;
int               g_value_adc_0;

unsigned int      g_count_adc_1;
int               g_value_adc_1;
static int        g_temperature_not_ready_value = 100;

unsigned int      g_led_control;
int      g_connect_mode;
char     g_uart_send_buf[MAX_RECIEVE_BUF];
extern enum alert_mode_e    g_alert_led_mode;

void get_status_led()
{
   g_count_adc_1++;
   if(g_count_adc_1 > 100)
   {
      g_count_adc_1 = 0;
      g_value_adc_1 = read_adc(1) * 500 / 1023;
   }

   if(DOOR == IS_OPEN || INLET == IS_REMOVED)
   {
      g_alert_led_mode = door_open_or_inlet_removed;
      turnoff();
   }
   else if(NOZZLE == IS_BLOCKED)
   {
      g_alert_led_mode = nozzle_blocked;
      turnoff();
   }
   else if(g_value_adc_1 >= g_temperature_not_ready_value)
   {
      g_alert_led_mode = in_temperature_not_ready_mode;
      turnoff();
   }
   else
   {
      g_alert_led_mode = no_fault;
   }
}


void send_string(unsigned char *u)
{
   unsigned char n,i;
   n = strlen(u);
   for(i = 0; i < n; i++)
   {
      putchar(u[i]);
   }
   putchar('\r');
   putchar('\n');
}



void perform_status_led()
{
   static enum alert_mode_e prev_status = no_fault;
   g_led_control++;
   if(g_led_control >= 10000)
      g_led_control = 0;
   
   switch(g_alert_led_mode)
   {
      case no_fault:
      {
         LED_GREEN = STATUS_ON;
         LED_RED = STATUS_OFF;
         break;
      }
      case nozzle_blocked:
      {
         if(g_led_control % DELAY_DIV_NUM == 0)
         {
            LED_GREEN = !LED_GREEN;
            LED_RED = LED_GREEN;
         }
         break;
      }
      case in_maintenance_mode:
      {
         if(g_led_control % DELAY_DIV_NUM == 0)
         {
            LED_GREEN = !LED_GREEN;
            LED_RED = !LED_GREEN;
         }
         break;
      }
      case in_temperature_not_ready_mode:
      {
         if(g_led_control % DELAY_DIV_NUM == 0)
         {
            LED_GREEN = !LED_GREEN;
         }
         LED_RED = STATUS_OFF;
         break;
      }
      case door_open_or_inlet_removed:
      {
         if(g_led_control % DELAY_DIV_NUM == 0)
         {
            LED_RED = !LED_RED;
         }
         LED_GREEN = STATUS_OFF;
         break;
      }
      case serial_link_to_siu_fault:
      {
         if(g_led_control % DELAY_DIV_NUM == 0)
         {
            LED_RED = !LED_RED;
         }
         LED_GREEN = STATUS_ON;
         break;
      }
      case other_fault:
      {
         LED_RED = STATUS_ON;
         LED_GREEN = STATUS_OFF;
         break;
      }
      case led_check:
      {
         LED_RED = STATUS_ON;
         LED_GREEN = STATUS_ON;
         break;
      }
      default:
         break;
   }
   if(g_alert_led_mode != no_fault && g_led_control % DELAY_SEND_ERR_DIV_NUM == 0)
   {
      memset(g_uart_send_buf,0,sizeof(g_uart_send_buf));
      sprintf(g_uart_send_buf, "err,%d;", g_alert_led_mode); 
      send_string(g_uart_send_buf);
      CONTROL_5V_12V = RUN_5V;
      prev_status = g_alert_led_mode;
   }
   else if(g_alert_led_mode == no_fault && prev_status != no_fault)
   {
      memset(g_uart_send_buf,0,sizeof(g_uart_send_buf));
      sprintf(g_uart_send_buf, "err,%d;", g_alert_led_mode); 
      send_string(g_uart_send_buf);
      prev_status = g_alert_led_mode;
   }
   ALARM = LED_RED;
}

void run_connect_mode()
{
   g_count_adc_0++;
   if(g_count_adc_0 >= TIMEOUT_ON_MODE && g_connect_mode == ON_MODE)
   {
      // Read adc and sent via uart
      g_count_adc_0 = 0;
      g_value_adc_0 = read_adc(0);
      memset(g_uart_send_buf,0,sizeof(g_uart_send_buf));
      sprintf(g_uart_send_buf, "adc,%d;", g_value_adc_0); 
      send_string(g_uart_send_buf);
   }else if(g_count_adc_0 >= TIMEOUT_STARTING_MODE && g_connect_mode == STARTING_MODE){
      // Sau khi nhan duoc lenh CONNECT, chay TIMEOUT_STARTING_MODE lan timer, sau do thay doi ve trang thai on mode
      QUAT = ON_5V;
      CONTROL_5V_12V = RUN_5V;
      SENSOR_1 = STATUS_ON;
      g_count_adc_0 = 0;
      g_connect_mode = ON_MODE;
   }else if(g_count_adc_0 >= TIMEOUT_STARTING_MODE){
      g_count_adc_0 = 0;
   }
}

void recieve_string(char* buf)
{
   int i = 0;
   char u = getchar();
   while(1){
      if(u != ';' && i < MAX_RECIEVE_BUF){
         buf[i] = u;
         i++;
         u = getchar();
      }else{
         break;
      }
   }
   i++;
   buf[i] = '\0';
}

void connect_avr()
{
   // Bat ADC
   // ADCSRA=(1<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
   g_count_adc_0 = 0;
   QUAT = OFF_5V;
   CONTROL_5V_12V = RUN_12V;
   g_connect_mode = STARTING_MODE;
}

void turnoff()
{
   // Tat adc
   // ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADFR) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (1<<ADPS1) | (1<<ADPS0);
   g_count_adc_0 = 0;
   CONTROL_5V_12V = RUN_5V;
   QUAT = STATUS_OFF;
   SENSOR_1 = STATUS_OFF;  
   g_connect_mode = OFF_MODE;
}


int strcasecmp(const char *s1, const char *s2) {
    const unsigned char *us1 = (const unsigned char *)s1,
                        *us2 = (const unsigned char *)s2;

    while (tolower(*us1) == tolower(*us2++))
        if (*us1++ == '\0')
            return (0);
    return (tolower(*us1) - tolower(*--us2));
}

void execute_command(char* buf)
{
   char* temp_cmd;
   temp_cmd = strtok(buf, ",");
   if(!strcasecmp(temp_cmd,"CONNECT"))
   {
      // Bat quat to trong 1 phut, sau do bat sensor
      connect_avr();
   }
   else if(!strcasecmp(temp_cmd,"OFF"))
   {
      // Tat quat nho, dung lay du lieu 
      turnoff();
   }
   else if(!strcasecmp(temp_cmd,"threshold"))
   {   
      g_led_control = 1;
      temp_cmd = strtok(NULL, ",");
      if(temp_cmd != NULL)
      {
         g_temperature_not_ready_value = atoi(temp_cmd);
         memset(g_uart_send_buf,0,sizeof(g_uart_send_buf));
         //sprintf(g_uart_send_buf, "thres,%d;", g_temperature_not_ready_value); 
         send_string(g_uart_send_buf);
      }
   }
}
