% function: reschedule
% last modified: 13/01/13
% description: It goes through entries in scheduled.mat. Check if they have
%              payments, not yet effected, in the past. If so, executes
%              those updating income.mat, expense.mat as necessary.
%              scheduled.mat will also be updated because it includes the
%              last date recorded in MYOD
function reschedule()

% load scheduled payments; go through one at a time
scheduled = load_data('sched');
sched_updated = false; %boolean: true if scheduled data should be updated
for i = 1:size(scheduled,1)
    
   
    
    increment = scheduled(i,data_num('s_increment'));
    switch scheduled(i,data_num('s_field'))
        case 1
            field = 'day';
        case 2
            field = 'month';
        case 3
            field = 'year';
    end
   
   quantity = scheduled(i,data_num('s_quantity')); %quantity of units of
                                                   %field to add to date0
   date0 = scheduled(i,data_num('date')); % initial date as a number
   today = datenum(date); % current date as a number
   datet = addtodate(date0,quantity,field); %next scheduled date   
   
   cashflow = []; %any scheduled transactions in the past to be added
    while datet <= today %make matrix of past transactions, if any       
        cashflow = [cashflow; scheduled(i,1:data_num('columns'))];
        cashflow(end, data_num('date')) = datet; %update date
        quantity = quantity + increment; %update quantity
        sched_updated = true; % now there is a reason to update scheduled
        datet = addtodate(date0,quantity,field); %next scheduled date        
    end
    
    % save new income/expense data
    if size(cashflow,1) && scheduled(i,data_num('amount')) > 0 %expense
        expense = load_data('exp');
        
        if size(expense,1) > 0 %check if new expense already exist
            t_expense = expense;
            t_expense(:,data_num('amount')) = 0;
            t_new = cashflow;
            t_new(:,data_num('amount')) = 0;
            [existing_row, corr_row] = ismember(t_expense,t_new,'rows');
        else
            existing_row = 0;
        end
        if existing_row %add amount to existing entry
            expense(existing_row,data_num('amount')) = ...
                expense(existing_row,data_num('amount')) + ...
                cashflow(corr_row,data_num('amount'));
            cashflow(corr_row,:) = []; % remove rows that have been included
        end
        expense = [expense; cashflow]; %add unique entries


        save_data(expense,'exp');
    elseif size(cashflow,1) % income
        income = load_data('inc');
        
        if size(income,1) > 0 %expense must exist
            t_income = income;
            t_income(:,data_num('amount')) = 0;
            t_new = cashflow;
            t_new(:,data_num('amount')) = 0;
            [existing_row, corr_row] = ismember(t_income,t_new,'rows');
        else
            existing_row = false;
        end
        if existing_row %add amount to existing entry
            income(existing_row,data_num('amount')) = ...
                income(existing_row,data_num('amount')) + ...
                cashflow(corr_row,data_num('amount'));
            cashflow(corr_row,:) = []; % remove rows that have been included
        end
        income = [income; cashflow]; %add unique entries
       
        save_data(income,'inc');
    end
    
    scheduled(i,data_num('s_quantity')) = quantity; %update quantity
    
end
if sched_updated
    save_data(scheduled,'sched');
end
end





