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



% function: pick_cats
% last modified: 25/02/13
% description: extracts only those categories selected
% inputs: cats - 2 column category matrix, each row represents a main_cat,
%                sub_cat. If sub_cat = 0, acts as a wildcard (all sub_cats
%                for that main_cat).
%         data - MYOD formatted cashflow data to be filtered
%         keep_cats - boolean; if true the function will return the rows
%                              with the categories in cats
%                              if false the function returns the rows not
%                              with the categories in cats
% outputs: data - a reduced form of data filtered according to
%                          cats and keep_cats
function data = pick_cats(cats, data, keep_cats)

if keep_cats
    op = '';
else
    op = '~';
end

% first ignore all main_cat with a sub_cat of 0 (the wildcard, *)
[rows ~] = find(~cats); %rows in cats with wildcard (0)
main_w_idx = cats(rows); % wildcard main_cat indices column vector
data_main = data(:, data_num('main_cat')); %extract data's main_cat
eval(['main_keepers = ' op 'ismember(data_main, main_w_idx,''rows'');']); %rows to retain
cats(rows,:) = []; % update cats

% remove individual subcategories from data
% extract data categories
data_cats = data(:, [data_num('main_cat') data_num('sub_cat')]);
eval(['sub_keepers = ' op 'ismember(data_cats, cats,''rows'');']); %rows to retain

% filter data
if keep_cats
    keepers = main_keepers | sub_keepers;
else
    keepers = main_keepers & sub_keepers;
end
data = data(keepers, :); 


























