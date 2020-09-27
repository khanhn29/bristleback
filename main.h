#ifndef MAIN_H
#define MAIN_H

#define MAX_RECIEVE_BUF 50

#define OFF_5V 0
#define ON_5V 1

#define RUN_5V 0
#define RUN_12V 1

#define STATUS_OFF 0
#define STATUS_ON 1

#define STARTING_MODE 2
#define ON_MODE 1
#define OFF_MODE 0

#define TRUE 1
#define FALSE 0

#define TIMEOUT_ON_MODE 50 //Thoi gian giua moi lan gui adc
#define TIMEOUT_STARTING_MODE 500 //Thoi gian bat quat sau khi nhan duoc tin hieu bat

#define QUAT PORTC.0
#define CONTROL_5V_12V PORTC.1 //Dieu khien relay su dung 5V hay 12V
#define SENSOR_1 PORTC.3
#define LED_GREEN PORTC.5
#define LED_RED PORTC.7
#define ALARM PORTA.7

#define DOOR PINA.1
#define IS_OPEN 1
#define IS_CLOSE 0

#define INLET PINA.3
#define IS_REMOVED 1
#define IS_NOT_REMOVED 0

#define NOZZLE PINA.5
#define IS_BLOCKED 0
#define IS_NOT_BLOCKED 1

#define DELAY_DIV_NUM 40
#define DELAY_SEND_ERR_DIV_NUM 100

enum alert_mode_e
{
   no_fault,
   nozzle_blocked,
   in_maintenance_mode,
   in_temperature_not_ready_mode,
   door_open_or_inlet_removed,
   serial_link_to_siu_fault,
   other_fault,
   led_check
};

void run_connect_mode();
void perform_status_led();
void get_status_led();
void send_string(unsigned char *u);
void perform_status_led();
void run_connect_mode();
void recieve_string(char* buf);
void connect_avr();
void turnoff();
void execute_command(char* buf);
unsigned int read_adc(unsigned char adc_input);
#endif