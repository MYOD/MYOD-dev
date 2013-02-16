% function: get_sub_cat
% last modified: 19/11/12
% description: Look-up table for sub_cat (dependent on main_cat,
%              hence the requirement for main_key)
% inputs: control - string; values should be 'string', 'index', 'list',
%                   'cell'  or 'array' if the user wishes to know the 
%                   string, index, list, cell or array respectively.
%                   'Cell' is for display purposes. The user provides an
%                   array of indices and a cell holding the corresponding
%                   strings will be returned.
%                   'List' will return all of the options as a cell of
%                   strings.
%                   'array' returns an column array of indices
%                   corresponding to the strings in the cell provided by
%                   the user.
%         main_key- may be the string or index of the corresponding
%                   main_cat value unless control is set to 'cell'.
%                   In which case it must be an array of
%                   indices of corresponding main_cat (to the sub_cat)
%         sub_key - if control='string', should be the corresponding index
%                   of sub_cat
%                   if control='index', should be the corresponding string
%                   of sut_cat
%                   if control='list', it is ignored; use dummy value
%                   if control='cell', sub_key should be an array of indices
%                   if control='array', sub_key should be a cell of strings
% outputs: result - can be the corresponding string, index, cell or list for
%                   sub_cat depending on the value of control
% NOTE: There is no error checking of the inputs
function result = get_sub_cat(control, main_key, sub_key)

% construct full list of sub categories
big_list{1} = ...%main 1, Shopping
    {'Fruit & Veg',... %sub 1
    'Butcher',... %sub 2
    'Groceries',...%sub 3
    'Clothing',...%sub 4
    'Shoes',...%sub 5
    'Bags',...%sub 6
    'Alcohol',...%sub 7
    'Health/Beauty', ...%sub 8
    'Others', ...%sub 9
    'Bakery', ...%sub 10
    };
big_list{2} = ...%main 2, Dining
    {'Restaurant',...%sub 1
    'Fast Food',...%sub 2
    'Snacks',...%sub 3
    'Drinks',...%sub 4
    'Others',...%sub 5
    'Coffee/Cake'...%sub 6
    };
big_list{3} = ...%main 3, Entertainment
    {'Cinema',...%sub 1
    'Others',... %sub 2
    'Exercise'...%sub 3
    };
big_list{4} = ...%main 4, Holidays 
    {'Local',...%sub 1
    'Interstate',...%sub 2
    'International'}; %sub 3
big_list{5} = ...%main 5, Accomodation
    {'Rent',... %sub 1
    'Bond',... %sub 2
    'Furniture',... %sub 3
    'Kitchenware',... %sub 4
    'Bedding',... %sub 5
    'Others',...%sub 6
    'Laundry/Bathroom',...%sub 7
    'Garden/Backyard'...sub 8
    }; %sub 6
big_list{6} = ...%main 6, Bills
    {'Electricity',...%sub 1
    'Water',...%sub 2
    'Gas',...%sub 3
    'Internet',...%sub 4
    'Mobile'}; %sub 5
big_list{7} = ...%main 7, Loans
    {'Borrow',...%sub 1
    'Lend'}; %sub 2
big_list{8} = ...%main 8, Vehicle
    {'Bus Tickets',...%sub 1
    'Smart Salary',...%sub 2
    'Fines',...%sub 3
    'Others',...%sub 4
    'Parking',...%sub 5
    'Petrol',...%sub 6
    'Service',...%sub 7
    'Tyres'...sub 8
    };
big_list{9} = ...%main 9, Presents
    {'Peter',...%sub 1
    'Carrie',...% sub 2
    'Peter''s Family',...%sub 3
    'Carrie''s Family',...%sub 4
    'Friends',...%sub 5
    'Others'...%sub 6
    };
big_list{10} = ...%main 10, Job
    {'Peter',...%sub 1
    'Carrie',...%sub 2
    };
big_list{11} = ...%main 11, Others
    {'Others',...%sub 1
    'Charity',...% sub 2
    'Tax Return',...% sub 3
    'Health Insurance',...%sub 4
    'Carrie''s Medical',... %sub 5
    'Peter''s Medical'... %sub 6
    };
big_list{12} = ...%main 12, Investments
    {'Education',...%sub 1
    'Others',...% sub 2
    'Networking'...% sub 3
    };


if ~isnumeric(main_key) % if user supplied a string
    main_key = get_main_cat('index',main_key); % convert to numbers
end

list = big_list{main_key}; %sub list; not relevant if control='cell'

switch control
    case 'string'
        result = list{sub_key};
    case 'index'
        result = find(ismember(list,sub_key));
    case 'list'
        result = list;
    case 'cell'
        %NOTE: cannot think of any solution other than iterative
        result = big_list(main_key)'; %first set each cell to appropiate sub list
        for i = 1:max(size(main_key)) %then...
           result{i} = result{i}{sub_key(i)}; %overwrite with desired element 
        end
    case 'array'
        if size(sub_key,2) > 1
            sub_key = sub_key'; %return vert array
        end
        result = zeros(size(sub_key,1),1);
        for i= 1:size(list,2)
            result = result + i.*ismember(sub_key,list{i});
        end
end
