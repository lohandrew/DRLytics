%% Initialisation - Creating the file list

% This script is developed by Andrew Loh (DRLytics) and is strictly for
% research use only.
% For futher information please contact: lohandrew1989@gmail.com
% Please cite this script as required:
% Developed year: 2021
% Developer: Andrew Loh
% Affiliation: Korea Institute of Ocean Science and Technology
% Script Function/Name: Data Processing and Extraction for 2-Dimensional GC Mass Spectrometry

%% SCRIPT CONTENT %%
% 1. Establishing DesignFile
% 2. Identifying compounds which have different masses
%   2.1 Defining UniqueMass & QuantMass
%   2.2 Converting cell to mat format
%   2.3 Finding compounds with similar UniqueMass & QuantMass
% 3. Removing compounds with different masses
%   3.1 Defining new UniqueMass & QuantMass
%   3.2 Display DesignFileNew
% 4. Removing solvent peaks
%   4.1 Defining solvent peaks
%   4.2 Converting cell to mat format
%   4.3 Finding compounds with Dim_1 > 250
%   4.4 Display DesignFileNew_2
% 5. Grouping compounds according to functional group
%   5.1 Defining Formula from DesignFile
%   5.2 Separating Elements and Numbers from compounds
%   5.3 Displaying Elements into tables
% 6. Finding N containing compounds
%   6.1 Finding presence of N within the Formula
%   6.2 Display Design_N
% 7. Finding Cl containing compounds
%   7.1 Finding presence of Cl within the Formula
%   7.2 Display Design_Cl
% 8. Finding Br containing compounds
%   8.1 Finding presence of Br within the Formula
%   8.2 Display Design_Br
% 9. Finding O containing compounds
%   9.1 Finding O containing compounds
%   9.2 Display Design_O
% 10. Finding F containing compounds
%   10.1 Finding F containing compounds
%   10.2 Display Design_F

%% 1. Establishing DesignFile

DesignFile = which('GC_GC_TOF.xls');
% User define's path

SampleID = 'S18-481'; % Insert sample name
Design_N = SampleID;

% Read DesignFile
[~,~,X_Design] = xlsread(DesignFile,SampleID);

% Excluding title heading from DesignFile
Design = X_Design(2:end,:);


%% 2. Identifying compounds which have different masses

% 2.1 Defining UniqueMass & QuantMass
UniqueMass = Design(:,8);
QuantMass = Design(:,9);

% 2.2 Converting cell to mat format
UniqueMass_2 = cell2mat(UniqueMass);
QuantMass_2 = cell2mat(QuantMass);

% 2.3 Finding compounds with similar UniqueMass & QuantMass
Compare_var = UniqueMass_2 == QuantMass_2;

%% 3. Removing compounds which have different masses

% 3.1 Defining new UniqueMass & QuantMass
Included_UniqueMass = UniqueMass(Compare_var,:);
Included_QuantMass = QuantMass(Compare_var,:);

% 3.2 Display new DesignFile
% Samples in DesignFile only with similar UniqueMass & QuantMass
IncludedSample = Design(Compare_var,:);
DesignNew = IncludedSample;

clear UniqueMass; clear QuantMass;clear UniqueMass_2; clear QuantMass_2;
clear Included_QuantMass; clear Included_UniqueMass;
clear Compare_var; clear IncludedSample;

%% 4. Removing solvent peaks %%

% 4.1 Defining solvent peaks
Dim_1 = DesignNew(:,4);
Dim_2 = DesignNew(:,5);

% 4.2 Converting cell to mat format
Dim_1_2 = cell2mat(Dim_1);
Dim_2_2 = cell2mat(Dim_2);

% 4.3 Finding samples with Dim_1 > 250
Compare_Dim_1 = Dim_1_2 > 250;

% Note: Do not remove parameters Dim_2 < 4 seconds as all other peaks will
% be removed as well

% 4.4 Display new DesignFile
% samples in DesignFile with Dim_1 > 250
IncludedSample_2 = DesignNew(Compare_Dim_1,:);
DesignNew2 = IncludedSample_2;

clear Dim_1; clear Dim_2; clear Dim_1_2; clear Dim_2_2; clear Compare_Dim_1;
clear IncludedSample_2;

%% 5. Grouping compounds according to their functional group

% 5.1 Defining Formula from DesignFile
Formula = DesignNew2(:,6);

% 5.2 Separating Elements and Numbers from compounds
numbers = regexp(Formula,'(\d+)','match');
chars =  regexp(Formula,'([a-z]+)|([A-Z]+)','match');

% 5.3 Displaying Elements into tables
% chars is displayed as cell array and it cannot be read as mat form so
% perform vertcat and transform into cells form
M = max(cellfun(@numel, chars));
chars2 = cellfun(@(row)[row (cell(1,M-numel(row)))], chars, 'uni', 0);
for idx = 1:numel(chars2)
    chars2{idx}(cellfun(@isempty, chars2{idx})) = {0};
end
 chars3=vertcat(chars2{:});

clear M; clear idx; clear chars2; clear chars; clear i;
 
%% 6. Finding N containing compounds

N_containing = strcmp(chars3, 'N');

% 6.1 Finding presence of N within the Formula
% Finding true values within the logical rows
N_presence = any(N_containing');
N_presence = N_presence'; % Convert rows to columns since "any(N_containing')" is only for columns %

% 6.2 Display new Designfile
IncludedSample = DesignNew2(N_presence,:);
Design_N = IncludedSample;

%%

FunctionHandle = str2func(Design_N);
f = @(data,h)FunctionHandle(data,h);

%% clear N_presence; clear N_containing; clear IncludedSample;  

%% 7. Finding Cl containing compounds

Cl_containing = strcmp(chars3, 'l');

% 7.1 Finding presence of Cl within the Formula
% Finding true values within the logical rows
Cl_presence = any(Cl_containing');
Cl_presence = Cl_presence'; % Convert rows to columns since "any(Cl_containing')" is only for columns %

% 7.2 Display new Designfile
IncludedSample = DesignNew2(Cl_presence,:);
Design_Cl = IncludedSample;

clear Cl_presence; clear Cl_containing; clear IncludedSample;  

%% 8. Finding Br containing compounds

Br_containing = strcmp(chars3, 'r');

% 8.1 Finding presence of Br within the Formula
% Finding true values within the logical rows
Br_presence = any(Br_containing');
Br_presence = Br_presence'; % Convert rows to columns since "any(Br_containing')" is only for columns %

% 8.2 Display new Designfile
IncludedSample = DesignNew2(Br_presence,:);
Design_Br = IncludedSample;

clear Br_presence; clear Br_containing; clear IncludedSample;  

%% 9. Finding O containing compounds

O_containing = strcmp(chars3, 'O');

% 9.1 Finding presence of O within the Formula
% Finding true values within the logical rows
O_presence = any(O_containing');
O_presence = O_presence'; % Convert rows to columns since "any(O_containing')" is only for columns %

% 9.2 Display new Designfile
IncludedSample = DesignNew2(O_presence,:);
Design_O = IncludedSample;

clear O_presence; clear O_containing; clear IncludedSample;  

% Note: O here also includes carboxylic acid, need to refer to "O_presence"
% and refer to the numbers after "O" based on the logical and if is < 0

%% 10. Finding F containing compounds

F_containing = strcmp(chars3, 'F');

% 9.1 Finding presence of F within the Formula
% Finding true values within the logical rows
F_presence = any(F_containing');
F_presence = F_presence'; % Convert rows to columns since "any(F_containing')" is only for columns %

% 9.2 Display new Designfile
IncludedSample = DesignNew2(F_presence,:);
Design_F = IncludedSample;

clear F_presence; clear F_containing; clear IncludedSample;


