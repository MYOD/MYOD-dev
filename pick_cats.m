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