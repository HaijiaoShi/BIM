function matches = fuzzyMatch(val1, val2)
    % Ensure the inputs are strings and check for semicolons
    if ismissing(val1) || ismissing(val2) || contains(val1, ';') || contains(val2, ';')
        matches = false;
        return;
    end

    val1 = char(val1);  % Convert to char if not already
    val2 = char(val2);  % Convert to char if not already

    % Split the EC numbers into parts
    parts1 = strsplit(val1, '.');
    parts2 = strsplit(val2, '.');

    % Check if both have the same number of parts
    if length(parts1) ~= length(parts2)
        matches = false;
        return;
    end

    % Compare each part
    for i = 1:length(parts1)
        if ~strcmp(parts2{i}, '-') && ~strcmp(parts1{i}, parts2{i})
            matches = false;
            return;
        end
    end

    matches = true;
end
