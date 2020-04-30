clear
format compact
NumberOfCars=0;
a=arduino('com5','Uno','libraries','servo, Ultrasonic, ExampleLCD/LCDAddon','ForceBuild',true);
lcd=addon(a,'ExampleLCD/LCDAddon','RegisterSelectPin','D7','EnablePin','D6','DataPins',{'D5','D4','D3','D2'});
initializeLCD(lcd);
s=servo(a,'D9','MinPulseDuration',700*10^-6,'Maxpulseduration',2300*10^-6);
ultrasonicObj1 = ultrasonic(a,'D8');
ultrasonicObj2 = ultrasonic(a,'D11');
configurePin(a,'A1','DigitalInput');
configurePin(a,'A2','DigitalInput');
writeDigitalPin(a,'D13',1);
writeDigitalPin(a,'D12',0);
clearLCD(lcd);
printLCD(lcd,'Welcome!!');
while 1
    enter_push=readDigitalPin(a,'A1')
    exit_push=readDigitalPin(a,'A2')
    enter_ultra=readDistance(ultrasonicObj1)
    exit_ultra=readDistance(ultrasonicObj2)
    if NumberOfCars<13
        if enter_ultra<=0.07 | enter_push==true
            clearLCD(lcd);
            printLCD(lcd,'Welcome!!')
            NumberOfCars=NumberOfCars+1;
            writeDigitalPin(a,'D12',1);
            writeDigitalPin(a,'D13',0);
            str1='Total cars = ';
            str2=num2str(NumberOfCars);
            printLCD(lcd,strcat(str1,str2));
            for angle = 0:0.005:0.55
                writePosition(s, angle);
                pause(0.01);
            end
            pause(2);
            for angle = 0.55:-0.005:0
                writePosition(s, angle);
                pause(0.01)
            end
        end
        writeDigitalPin(a,'D12',0);
        writeDigitalPin(a,'D13',1);
    else
        clearLCD(lcd);
        printLCD(lcd,'Come later');
    end
    
    if NumberOfCars>=1
        if exit_ultra<=0.07 | exit_push==true
            writeDigitalPin(a,'D12',1);
            writeDigitalPin(a,'D13',0);
            clearLCD(lcd);
            printLCD(lcd,'Thanks for visit')
            NumberOfCars=NumberOfCars-1;
            str1='Total cars = ';
            str2=num2str(NumberOfCars);
            printLCD(lcd,strcat(str1,str2));
            for angle = 0:0.005:0.55
                writePosition(s, angle);
                pause(0.01);
            end
            pause(2);
            for angle = 0.55:-0.005:0
                writePosition(s, angle);
                pause(0.01)
            end
        end
        writeDigitalPin(a,'D12',0);
        writeDigitalPin(a,'D13',1);
    end
end