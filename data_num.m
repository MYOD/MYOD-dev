% function: data_num
% last modified: 13/01/13
% description: This method acts as a lookup table for any other function
%              that needs to access MYOD income/expense data. 
% inputs: descriptor - a string to describe the value to be returned
% outputs: num - the number found
function num = data_num(descriptor)

switch descriptor
    case 'columns'
        num = 5;
    case 'date' % (initial) date
        num = 1; 
    case 'amount'
        num = 2;
    case 'fund'
        num = 3;
    case 'main_cat'
        num = 4;
    case 'sub_cat'
        num = 5;
    case 'path' %relative path to MYOD data
        num = 'MYOD_data';
    case 's_field' %scheduled payment - 1=day, 2=month 3=year
        num = 6;
    case 's_quantity' %scheduled payment - quantity of units (of field)
        num = 7;  %                    since the initial date 
    case 's_increment' %scheduled payment - increment of units between transactions
        num = 8; 
    case 's_columns' %scheduled payment - number of columns
        num = 8;
    case 'rel_path' %abs path to release version of MYOD
        num = 'D:\MYOD';
end