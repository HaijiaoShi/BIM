function Cflat = flattenCell(C,strFlag)
if nargin < 2
    strFlag = false;
end

% determine which entries are cells
cells = cellfun(@iscell,C);

% determine number of elements in each nested cell
cellsizes = cellfun(@numel,C);
cellsizes(~cells) = 1;  % ignore non-cell entries

% flatten single-entry cells
Cflat = C;
Cflat(cells & (cellsizes == 1)) = cellfun(@(x) x{1},Cflat(cells & (cellsizes == 1)),'UniformOutput',false);

% iterate through multi-entry cells
multiCells = find(cellsizes > 1);
for i = 1:length(multiCells)
    cellContents = Cflat{multiCells(i)};
    Cflat(multiCells(i),1:length(cellContents)) = cellContents;
end

% change empty elements to strings, if specified
if ( strFlag )
    Cflat(cellfun(@isempty,Cflat)) = {''};
end
