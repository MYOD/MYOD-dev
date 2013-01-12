% function: summarise
% last modified: 06/01/13
% description: refreshes the text display on MYOD
% inputs: handles - MYOD gui data
function summarise(handles)


% MYOD formatted data
expense = load_data('exp'); 
exclusions = load_data('exc'); %categories to ignore

if size(expense,1) ~= 0 %do have expense data 

% remove excluded expenses
% first ignore all main_cat with a sub_cat of 0 (the wildcard, *) 
[rows ~] = find(~exclusions); %rows in exclusions with wildcard
no_m = exclusions(rows); % main_cats to ignore
main_cats = expense(:, data_num('main_cat')); %extract expenses main_cat
keepers = ~ismember(main_cats, no_m,'rows'); %rows to retain
expense = expense(keepers, :); %remove main_cats from expense
exclusions(rows,:) = []; % update exclusions
% remove individual subcategories from expense
% extract expense categories
exp_cats = expense(:, [data_num('main_cat') data_num('sub_cat')]);
keepers = ~ismember(exp_cats, exclusions,'rows'); %rows to retain
expense = expense(keepers, :); %remove these from expense

% calculate expenditure in last week
date_end = datenum(date); %todays date as a number
date_start = date_end - 13; %two weeks ago (inclusive)
row_idx = (expense(:,data_num('date')) >= date_start) & ...
    (expense(:,data_num('date')) <= date_end);
last_week = sum(expense(row_idx,data_num('amount')))/2;
last_week = num2str(last_week,'%-0.2f'); %convert to a string with 2 decimal places
last_week = strcat('$',last_week); %prefix $

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
    'On average, every week you spend: %s\n' ...
    'Number of days average calculated over: %d\n'], ...
    last_week,weekly_spend, days);

else % don't have expense data
    summary = 'No expense data found!';
end

% display summary string
set(handles.summary, 'String', summary);
