%% protocol numbers: 
%   1=stepper, 2=longIV, 3=test_IV, 4=ramp_IV, 5=ramptime_IV, 6=PP,
%   7=jitter


clear all
%%
%--use standard protocol numbers assigned during analysis to summarize
% stimulation-protocol specific data of each neuron into one table
filenames=uipickfiles;

for z=1:size(filenames,2)
    clearvars results result_table
    results=load(filenames{1,z});


    rec_name=fieldnames(results);

    prot_names=fieldnames(results.(rec_name{1,1}));

    for i=1:size(prot_names,1)
        clearvars parameter_names result_table
        parameter_names=fieldnames(results.(rec_name{1,1}).(prot_names{i,1}));

    
        for j=1: size(parameter_names,1)
            prot_no=results.(rec_name{1,1}).(prot_names{i,1}).(parameter_names{j,1}){1,2};            
            result_table{j,1}=parameter_names{j,1};
            result_table{j,2}=results.(rec_name{1,1}).(prot_names{i,1}).(parameter_names{j,1}){1,1};
        end
    
        if prot_no==1
            stepper_results{1,1}='stepper';
    
            stepper_results{z+1,1}=filenames{1,z};
            for k=1:size(result_table,1)
                stepper_results{1,k+1}=result_table{k,1};
                stepper_results{z+1,k+1}=result_table{k,2};            
            end
        
        elseif prot_no==2
            longIV_results{1,1}='longIV';
            
            longIV_results{z+1,1}=filenames{1,z};
            for k=1:size(result_table,1)
                longIV_results{1,k+1}=result_table{k,1};
                longIV_results{z+1,k+1}=result_table{k,2};            
            end            
        
        elseif prot_no==3
            test_IV_results{1,1}='test_IV';
            
            test_IV_results{z+1,1}=filenames{1,z};
            for k=1:size(result_table,1)
                test_IV_results{1,k+1}=result_table{k,1};
                test_IV_results{z+1,k+1}=result_table{k,2};            
            end
            
        elseif prot_no==4
            ramp_IV_results{1,1}='ramp_IV';
            
            ramp_IV_results{z+1,1}=filenames{1,z};
            for k=1:size(result_table,1)
                ramp_IV_results{1,k+1}=result_table{k,1};
                ramp_IV_results{z+1,k+1}=result_table{k,2};            
            end
            
        elseif prot_no==5
            ramptime_IV_results{1,1}='ramptime_IV';
            
            ramptime_IV_results{z+1,1}=filenames{1,z};
            for k=1:size(result_table,1)
                ramptime_IV_results{1,k+1}=result_table{k,1};
                ramptime_IV_results{z+1,k+1}=result_table{k,2};            
            end
            
        elseif prot_no==6
            PP_results{1,1}='PP';
            
            PP_results{z+1,1}=filenames{1,z};
            for k=1:size(result_table,1)
                PP_results{1,k+1}=result_table{k,1};
                PP_results{z+1,k+1}=result_table{k,2};
               
            end
            
        elseif prot_no==7
            jitter_results{1,1}='jitter';
            
            jitter_results{z+1,1}=filenames{1,z};
            for k=1:size(result_table,1)
                jitter_results{1,k+1}=result_table{k,1};
                jitter_results{z+1,k+1}=result_table{k,2};            
            end
            
        end

    end
end

%% clear result-tables from empty cells

for i=1:size(stepper_results,1)
    if isempty(stepper_results{i,1})
        emp_rows(i,1)=i;
    end
end
if exist('emp_rows','var')
emp_rows(emp_rows==0)=[];
stepper_results(emp_rows,:)=[];
clearvars emp_rows
end

for i=1:size(longIV_results,1)
    if isempty(longIV_results{i,1})
        emp_rows(i,1)=i;
    end
end
if exist('emp_rows','var')
emp_rows(emp_rows==0)=[];
longIV_results(emp_rows,:)=[];
clearvars emp_rows
end

for i=1:size(test_IV_results,1)
    if isempty(test_IV_results{i,1})
        emp_rows(i,1)=i;
    end
end
if exist('emp_rows','var')
emp_rows(emp_rows==0)=[];
test_IV_results(emp_rows,:)=[];
clearvars emp_rows
end

for i=1:size(ramp_IV_results,1)
    if isempty(ramp_IV_results{i,1})
        emp_rows(i,1)=i;
    end
end
if exist('emp_rows','var')
emp_rows(emp_rows==0)=[];
ramp_IV_results(emp_rows,:)=[];
clearvars emp_rows
end

for i=1:size(jitter_results,1)
    if isempty(jitter_results{i,1})
        emp_rows(i,1)=i;
    end
end
if exist('emp_rows','var')
emp_rows(emp_rows==0)=[];
jitter_results(emp_rows,:)=[];
clearvars emp_rows
end
clearvars -except jitter_results stepper_results test_IV_results ramptime_IV_results...
            ramp_IV_results PP_results longIV_results