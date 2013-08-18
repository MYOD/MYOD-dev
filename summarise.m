% function: summarise
% last modified: 25/02/13
% description: refreshes the text display on MYOD
% inputs: handles - MYOD gui data
function summarise(handles)

% boolean to include enhancement whereby expense calculations factor
% in income as negative expense except for the "true income" which is
% ignored
neg_exp = true;

% MYOD formatted data
cashflow = [load_data('exp'); load_data('inc')];
exclusions = load_data('exc'); %categories to ignore

if size(cashflow,1) ~= 0 %do have cashflow data
    
    % filter MYOD cashflow as per user preferences
    cashflow = pick_cats(exclusions,cashflow,false); 
    expense = cashflow;
    
    if neg_exp
%       remove only true income
        true_inc = load_data('true_inc');
        expense = pick_cats(true_inc,expense,false);
    else
%       remove all income
        expense(cashflow(:,data_num('amount'))<0,:) = [];
    end
    
    % timeframe of last fortnight
    date_end = datenum(date); %todays date as a number
    date_start = date_end - 13; %two weeks ago (inclusive)

    % calculate gains over last 2 weeks
    row_idx = (cashflow(:,data_num('date')) >= date_start) & ...
        (cashflow(:,data_num('date')) <= date_end);     
    cash_fortnight = cashflow(row_idx,data_num('amount')); %cashflow last fortnight
    gainings = -sum(cash_fortnight); %how much money gained over past two weeks
    gainings = cur2str(gainings); %convert to money formatted string
    % gainings = num2str(gainings,'%-0.2f');
    % gainings = strcat('$',gainings); %format as money string
    
    % calculate running 2week average expenditure 
    row_idx = (expense(:,data_num('date')) >= date_start) & ...
        (expense(:,data_num('date')) <= date_end);
    exp_fortnight = expense(row_idx,data_num('amount')); %expenses last fortnight
    last_week = sum(exp_fortnight)/2;
    last_week = cur2str(last_week);
    
    % calculate average weekly spend
    date_start = min(expense(:,data_num('date')));
    days = date_end - date_start + 1;
    weeks = days / 7;
    weekly_spend = sum(expense(:,data_num('amount'))) / weeks;
    weekly_spend = cur2str(weekly_spend);
    
    % construct string to display
    summary = sprintf(['Hi, welcome to MYOD!\n' ...
        'Weekly average expenditure over the last fortnight: %s\n' ...
        'Over the last fortnight you have gained: %s\n' ...
        'On average, every week you spend: %s\n' ...
        'Number of days average calculated over: %d\n'], ...
        last_week,gainings,weekly_spend, days);
    
else % don't have cashflow data
    summary = 'No cashflow data found!';
end

% display summary string
set(handles.summary, 'String', summary);






























