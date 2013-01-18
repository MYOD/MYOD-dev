% function: summarise
% last modified: 18/01/13
% description: refreshes the text display on MYOD
% inputs: handles - MYOD gui data
function summarise(handles)


% MYOD formatted data
cashflow = load_data('all'); 
exclusions = load_data('exc'); %categories to ignore

if size(cashflow,1) ~= 0 %do have cashflow data 

% remove excluded cashflows
% first ignore all main_cat with a sub_cat of 0 (the wildcard, *) 
[rows ~] = find(~exclusions); %rows in exclusions with wildcard
no_m = exclusions(rows); % main_cats to ignore
main_cats = cashflow(:, data_num('main_cat')); %extract cashflows main_cat
keepers = ~ismember(main_cats, no_m,'rows'); %rows to retain
cashflow = cashflow(keepers, :); %remove main_cats from cashflow
exclusions(rows,:) = []; % update exclusions
% remove individual subcategories from cashflow
% extract cashflow categories
exp_cats = cashflow(:, [data_num('main_cat') data_num('sub_cat')]);
keepers = ~ismember(exp_cats, exclusions,'rows'); %rows to retain
cashflow = cashflow(keepers, :); %remove these from cashflow
expense = cashflow; 
expense(cashflow(:,data_num('amount'))<0,:) = [];

% calculate running 2week average expenditure & gains over last 2 weeks
date_end = datenum(date); %todays date as a number
date_start = date_end - 13; %two weeks ago (inclusive)
row_idx = (cashflow(:,data_num('date')) >= date_start) & ...
    (cashflow(:,data_num('date')) <= date_end);
cash_amount = cashflow(row_idx,data_num('amount')); %cashflow raw numbers
expense_amount = cash_amount;
expense_amount(expense_amount<0) = 0;  %expense raw numbers
last_week = sum(expense_amount)/2;
last_week = num2str(last_week,'%-0.2f'); %convert to a string with 2 decimal places
last_week = strcat('$',last_week); %prefix $
gainings = -sum(cash_amount); %how much money gained over past two weeks
gainings = cur2str(gainings); %convert to money formatted string
% gainings = num2str(gainings,'%-0.2f');
% gainings = strcat('$',gainings); %format as money string

% calculate average weekly spend
date_start = min(expense(:,data_num('date')));
days = date_end - date_start + 1;
weeks = days / 7;
weekly_spend = sum(expense(:,data_num('amount'))) / weeks;
weekly_spend = num2str(weekly_spend,'%-0.2f'); %convert to a string with 2 decimal places
weekly_spend = strcat('$',weekly_spend); %prefix $

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
