% function: get_main_cat
% last modified: 19/10/12
% description: acts as a lookup table for main_cat
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
%         key - lookup value
%               if control='string', should be corresponding index
%               if control='index', should be corresponding string
%               if control='list', key is ignored, use dummy value
%               if control='cell', key should be an array of indices
%               if control='array', key should be a cell of strings
% outputs: result - corresponding value for key
% NOTE: There is no error checking of the inputs
function result = get_main_cat(control, key)

list = {'Shopping',... %1
    'Dining',... %2
    'Entertainment',... %3
    'Holidays',... %4
    'Accomodation',... %5
    'Bills',... %6
    'Loans',... %7
    'Vehicle',... %8
    'Presents',... %9
    'Job',...%10
    'Others',...%11
    'Investments',...%12
    'Family'...%13
    };

switch control
    case 'string'
        result = list{key};
    case 'index'
        result = find(ismember(list,key));
    case 'list'
        result = list;
    case 'cell'
        result = list(key);
        result = result'; %return it as a vert cell
    case 'array'
        if size(key,2) > 1
            key = key'; %return vert array
        end
        result = zeros(size(key,1),1);
        for i= 1:size(list,2)
            result = result + i.*ismember(key,list{i});
        end
end


