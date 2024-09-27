% Initialize COBRA environment
initCobraToolbox(false) % Set the second parameter to true if COBRA is not installed

% Load the model
model = readCbModel('ec_G-ther11955.xml'); % Replace with your model file

% Set the initial range of total enzyme pool values
enzymePoolValues = linspace(200, 2000, 50); % Set the range for total enzyme pool values
% Preallocate variables to store growth rates and metabolic fluxes
growthRates = zeros(length(enzymePoolValues), 1);
fluxDistributions = zeros(length(enzymePoolValues), length(model.rxns));

% Perform sensitivity analysis
for i = 1:length(enzymePoolValues)
    % Set the current total enzyme pool value
    currentEnzymePool = enzymePoolValues(i);
    
    % Constrain the total enzyme pool in the model
    model = changeRxnBounds(model, 'prot_pool_exchange', currentEnzymePool, 'u'); % Assume 'prot_pool_exchange' is the total enzyme pool pseudo-reaction
    
    % Optimize the objective function (typically growth rate)
    solution = optimizeCbModel(model, 'max');
    
    % Store results
    growthRates(i) = solution.f; % Growth rate
    fluxDistributions(i, :) = solution.x; % Metabolic fluxes
end

% Plot the response curve of growth rate to the total enzyme pool
figure;
plot(enzymePoolValues, growthRates, '-o');
xlabel('Total Enzyme Pool Value');
ylabel('Growth Rate (1/h)');
title('Growth Rate Sensitivity to Total Enzyme Pool');

% If specific reaction flux sensitivity to the total enzyme pool needs to be analyzed, plot the corresponding curve
% For example, select a reaction of interest
reactionIndex = find(strcmp(model.rxns, 'biomass')); % Replace with your reaction of interest
figure;
plot(enzymePoolValues, fluxDistributions(:, reactionIndex), '-o');
xlabel('Total Enzyme Pool Value');
ylabel('Flux of Selected Reaction (mmol/gDW/h)');
title('Flux Sensitivity to Total Enzyme Pool');

writeCbModel(model)
