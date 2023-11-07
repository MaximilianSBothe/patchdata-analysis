%% How to use this skript:

% To use this script the "sigTOOL" toolbox has to be installed
% (https://sourceforge.net/projects/sigtool/files/sigtool/sigTOOL_Version_0.95/)

% Additionally, you need to install the Matlab patchmaster toolbox to load
% HEKA dat-Files into Matlab
% (https://github.com/wormsenseLab/Matlab-PatchMaster)
%
% Installation guides are provided with both toolboxes

% -All values are calculated and saved in standard SI-units (no unit-prefixes included)


%% Import data from experiment and pull structname

clearvars 
close all

patchmaster_data=ImportPatchData();
structname=fieldnames(patchmaster_data);
filename=patchmaster_data.(structname{1,1}).file;
save_filename=filename;
for i=1:size(filename,2)
    if save_filename(i)=='-'
        save_filename(i)='_';
    end
    if save_filename(i)==' '
        save_filename(i)='_';
    end
end

data=patchmaster_data.(structname{1,1}).data;
samplingrates=patchmaster_data.(structname{1,1}).samplingFreq;
for i=1:length(samplingrates)
    samplingrates{1,i}=round(samplingrates{1,i});
end

%% name applied protocols
protocol_name_inputs = {'Stepper prot.','longIV prot.','test_IV1 prot.', 'const_cc prot.',...
                     'rampIV prot','ramptimeIV prot.','PP prot.','Jitter prot.','Train prot.','const_VC prot.'};
prompt_title1 = 'Please enter changed protocol names if necessary';
dims1 = [1 75];

default_input1 = {'Stepper','longIV','test_IV1','1','rampIV','1','1','jitter','1','1'};        

%protocol_names = inputdlg(protocol_name_inputs,prompt_title1,dims1,default_input1);
protocol_names = default_input1';                 
                  

                  
steppername=protocol_names{1,1};
longIVname=protocol_names{2,1};
test_IV1name=protocol_names{3,1};
const_ccname=protocol_names{4,1};
rampIVname=protocol_names{5,1};
ramptimeIVname=protocol_names{6,1};
PPname=protocol_names{7,1};
Jittername=protocol_names{8,1};
Trainname=protocol_names{9,1};
const_VCname=protocol_names{10,1};
%% check for applied stimulus protocol

for i= 1: size(patchmaster_data.(structname{1,1}).protocols,2)
    protocol{1,i}=patchmaster_data.(structname{1,1}).protocols(1,i);
end
%% ANALYSIS
 
Stepper=0; longIV=0; test_IV1=0; const_cc=0; rampIV=0; ramptimeIV=0;
PP=0; Jitter=0; Train=0; const_VC=0;



filter_i=1;
if filter_i==1 
    experiments_to_analyse = inputdlg('Enter experiments as space-separated numbers:', 'Sample', [1 50]);
    experiments_to_analyse = str2num(experiments_to_analyse{1});
    
end


for i= 1: size(patchmaster_data.(structname{1,1}).data,2)
    clearvars -except  i patchmaster_data structname filename data samplingrates...
                      stimulus_recorded protocol Stepper longIV test_IV1 const_cc...
                      rampIV ramptimeIV PP Jitter Train const_VC steppername longIVname test_IV1name...
                      const_ccname rampIVname ramptimeIVname PPname Jittername Trainname const_VCname...
                      errornames results save_filename i_minis i_mini_locs i_minis_checked i_noise_checked...
                      decay_time_i_minis i_minis_maxamp e_minis e_mini_locs e_minis_checked e_noise_checked...
                      decay_time_e_minis e_minis_maxamp e_Mini_decay_pool e_Mini_maxamp_pool i_Mini_decay_pool...
                      i_Mini_maxamp_pool rawdata stimulusdata filter_i experiments_to_analyse 

if filter_i==1 && ismember(i,experiments_to_analyse)|| filter_i~=1 %this body ends in line 1331
                 
                 
    if strcmp(protocol{1,i},steppername)
        %%
        Stepper=Stepper+1;
        %define stepper parameters:
        %--input prompt--
        stepper_inputs = {'Number of Sweeps','Stepper amplitude [pA]','Pretrigger time [s]', 'Step time [s]',...
                  'Posttrigger time [s]'};
        prompt_title2 = ['Stepper parameters ' protocol{1,i}{1,1}];
        dims3 = [1 45];
        default_input2 = {num2str(size(data{1,i},2)),...
                   num2str((patchmaster_data.(structname{1,1}).stimTree{1,i}{4,3}.seVoltage-...
                      patchmaster_data.(structname{1,1}).stimTree{1,i}{2,2}.chHolding)*10^3),...
                   num2str(patchmaster_data.(structname{1,1}).stimTree{1,i}{3,3}.seDuration),...
                   num2str(patchmaster_data.(structname{1,1}).stimTree{1,i}{4,3}.seDuration),...
                   num2str(patchmaster_data.(structname{1,1}).stimTree{1,i}{5,3}.seDuration)};
        
        stepper_parameters = inputdlg(stepper_inputs,prompt_title2,dims3,default_input2);
        
        %--variable assignment--
        number_of_sweeps=str2num(stepper_parameters{1,1});
        stepper_amplitude1=(patchmaster_data.(structname{1,1}).stimTree{1,i}{4,3}.seVoltage-...
                      patchmaster_data.(structname{1,1}).stimTree{1,i}{2,2}.chHolding)*10^-9;        % in ampere
        pretrigger_time1=str2num(stepper_parameters{3,1});                                           % in seconds
        stepper_time=str2num(stepper_parameters{4,1});                                               % in seconds
        posttrigger_time1=str2num(stepper_parameters{5,1});                                          % in seconds
        stimulus_trace1=horzcat(zeros(1,round(pretrigger_time1*samplingrates{1,i})),...
                               zeros(1,round(stepper_time*samplingrates{1,i})),...
                               zeros(1,round(posttrigger_time1*samplingrates{1,i})))  ; 
        stimulus_trace1(pretrigger_time1*samplingrates{1,i}+1:pretrigger_time1*...
                        samplingrates{1,i}+stepper_time*samplingrates{1,i})=stepper_amplitude1;                                                   % in pA
        
        %plot raw data and their mean:
        f1=figure (i);

        set(f1, 'Units', 'normalized', 'Position',[0, 0, 1, 1]); 

        f1_x_axis=0:1/samplingrates{1,i}:size(data{1,i},1)/samplingrates{1,i};
        f1_x_axis=f1_x_axis(1:end-1);
        
        f_1_1=subplot(4,4,[1,2,5,6,9,10,13,14]);
        hold on
        for j=1:size(data{1,i},2)
            plot(f1_x_axis, data{1,i}(:,j)*1000,'color',[0,0,0]+0.6) %only displays data in mV, no change to data
        end
        plot(f1_x_axis, mean(data{1,i},2)*1000,'r','LineWidth',1.5)  %only displays data in mV, no change to data   
        hold off
        
        title([save_filename,' ,Stepper Stimulus, ',stepper_parameters{2,1},' pA, ' ,num2str(size(data{1,i},2)),' repetitions'],'interpreter','none'); 
        xlabel(['Time [s]']);
        ylabel(['Potential [mV]']);
                                
        % analyze data:
        mean_all_sweeps=mean(data{1,i},2);
        mean_resting_pot=mean(mean_all_sweeps(round(1:pretrigger_time1*samplingrates{1,i})));
        
        mean_stepperdrop=mean(mean_all_sweeps(round((pretrigger_time1+stepper_time-0.03)*samplingrates{1,i}):...
                                              round((pretrigger_time1+stepper_time)*samplingrates{1,i})));
        
        delta_V=mean_stepperdrop-mean_resting_pot;
        tau_pot=mean_resting_pot+(delta_V*0.63);        
        
        input_resistance=delta_V/stepper_amplitude1;  %in Ohm
        
        %--plot mean trace, resting potential, drop potential and tau:--
        subplot(4,4,[3,4,7,8])
        plot (f1_x_axis,mean_all_sweeps*1000,'k')
        hold on
        plot (f1_x_axis,mean_stepperdrop*ones(round(size(f1_x_axis,2)),1)*1000,'r')
        plot (f1_x_axis,mean_resting_pot*ones(round(size(f1_x_axis,2)),1)*1000,'g')
        for z=1:size(mean_all_sweeps)
            if mean_all_sweeps(z)<=tau_pot
                tau_index= (z-(pretrigger_time1*samplingrates{1,i}));
                tau= tau_index/samplingrates{1,i};
                plot(z/samplingrates{1,i},tau_pot*1000,'bo','MarkerFaceColor','b')
                plot (f1_x_axis,tau_pot*ones(round(size(f1_x_axis,2)),1)*1000,'b')
                break
            end
        end
        hold off
        
        membrane_capacitance=tau/input_resistance;      %in Farad
        
        title('Membrane property calculation');
        xlabel(['Time [s]']);
        ylabel(['Potential [mV]']);
        
        %--plot resultswindow:--
        results_window_text=sprintf(['Stepper #',num2str(Stepper),', applied as protocol #',num2str(i)...
                '\n\nMean resting: ' num2str(mean_resting_pot*1000),' mV'...
                '\nMean dropped: ' num2str(mean_stepperdrop*1000), ' mV'...
                '\ndelta V:' num2str((mean_stepperdrop-mean_resting_pot)*1000), ' mV'...
                '\nTau: ', num2str(tau*1000), ' ms'...
                '\nCAP.: ', num2str(membrane_capacitance*10^9),' nF'...     %in nFarad
                '\nInput res.:' num2str(input_resistance*10^-6), ' MOhm'...
                '\nHolding: ' num2str((patchmaster_data.(structname{1,1}).stimTree{1,i}{2,2}.chHolding)*10^3), ' pA' ]);

        dim1 = [.55 .18 .3 .3];
        annotation('textbox',dim1,'String',results_window_text,'FitBoxToText','on',...
                    'FontSize',9,'FontWeight','bold','horizontalAlignment', 'left');
        
        %-- plot stimulus trace:--
        subplot(4,4,[15,16])
        x_axis_stimulus=0:1/samplingrates{1,i}:size(stimulus_trace1,2)/samplingrates{1,i};
        x_axis_stimulus=x_axis_stimulus(1:end-1);
        plot(x_axis_stimulus,stimulus_trace1*10^12)
        ylim([(min(stimulus_trace1)*10^12)-1,1]);
        title('Stimulus');
        xlabel(['Time [s]']);
        ylabel(['Applied current [pA]']);
        
        %--save extracted data:--
        savedlg=menu('Save figure and results?','Yes','No');
        
        if savedlg==1
        parameternames={};
        parameternames={'Mean_resting_V','Mean_dropped_V','deltaV','Tau_s','CAP_F',...
                                'Inputs_res_OHM','Holding_current_A'; '[V]','[V]','[V]','s','F','OHM','[A]'}';
        
        hold_curr=patchmaster_data.(structname{1,1}).stimTree{1,i}{2,2}.chHolding*10^-9;
        parametervalues=[];
        parametervalues=[mean_resting_pot,mean_stepperdrop,mean_stepperdrop-mean_resting_pot,...
                        tau, membrane_capacitance,input_resistance, hold_curr ]';                    
        
            for j=1:size(parameternames,1)
                results.(['results_' save_filename]).(['Prot_no_' num2str(i) '_' steppername]).(parameternames{j,1})={parametervalues(j,1),1};

            end
        rawdata.(['rawdata_' save_filename]).(['Prot_no_' num2str(i) '_' steppername '_rawdata'])=data{1,i};
        stimulusdata.(['stimulusdata_' save_filename]).(['Prot_no_' num2str(i) '_' steppername '_stimulusdata']).stepper_amplitude=stepper_amplitude1;
        stimulusdata.(['stimulusdata_' save_filename]).(['Prot_no_' num2str(i) '_' steppername '_stimulusdata']).stepper_length=stepper_time;
        stimulusdata.(['stimulusdata_' save_filename]).(['Prot_no_' num2str(i) '_' steppername '_stimulusdata']).stepper_pretrigger=pretrigger_time1;
        
        saveas(f1,['figs\' filename '_' steppername '_prot_no_' num2str(i)])

            set(f1, 'PaperUnits', 'normalized');
            set(f1, 'PaperPosition', [0 0.1 1 .7]); 

        saveas(f1,['jpgs\' filename '_' steppername '_prot_no_' num2str(i)],'jpg')
        end
    
    elseif strcmp(protocol{1,i},longIVname)
        %%
        longIV=longIV+1;
        %define longIV parameters:
        %--input prompt--
        longIV_inputs = {'Number of Sweeps','Increment per step [pA]','Pretrigger time [s]', 'Step time [s]',...
                  'Posttrigger time [s]'};
        prompt_title2 = 'longIV parameters';
        dims2 = [1 45];
        default_input = {num2str(size(data{1,i},2)),num2str(patchmaster_data.(structname{1,1}).stimTree{1,i}{4,3}.seDeltaVIncrement*1000),...
                    num2str(patchmaster_data.(structname{1,1}).stimTree{1,i}{3,3}.seDuration)...
                    num2str(patchmaster_data.(structname{1,1}).stimTree{1,i}{4,3}.seDuration),...
                    num2str(patchmaster_data.(structname{1,1}).stimTree{1,i}{5,3}.seDuration)};
        longIV_parameters = inputdlg(longIV_inputs,prompt_title2,dims2,default_input);
        %--variable assignment--
        holding_current=patchmaster_data.(structname{1,1}).stimTree{1,i}{2,2}.chHolding*10^-9;   % in ampere
        number_of_sweeps=str2num(longIV_parameters{1,1});
        longIV_amplitude=str2num(longIV_parameters{2,1})*10^-12;                                 % in ampere
        pretrigger_time=str2num(longIV_parameters{3,1});                                         % in seconds
        longIV_time=str2num(longIV_parameters{4,1});                                             % in seconds
        posttrigger_time=str2num(longIV_parameters{5,1});                                        % in seconds
        effective_basis_current=(patchmaster_data.(structname{1,1}).stimTree{1,i}{4,3}.seVoltage-...
                      patchmaster_data.(structname{1,1}).stimTree{1,i}{2,2}.chHolding)*10^-9;     % in ampere
                  
        stimulus_trace=horzcat(zeros(1,round(pretrigger_time*samplingrates{1,i})),...
                               zeros(1,round(longIV_time*samplingrates{1,i})),...
                               zeros(1,round(posttrigger_time*samplingrates{1,i})))  ; 
        stimulus_trace(pretrigger_time*samplingrates{1,i}+1:pretrigger_time*...
                        samplingrates{1,i}+longIV_time*samplingrates{1,i})=1;                    %base trace for plotting longIV_amplitude;  
        
       %--set threshold for IF-Curve and extract values:--
       
       %--analyse dataset?
       f201=figure(201);
        plot(data{1,i}*1000,'k')
        title('longIV data');
        choice = menu('Analyse data?','Yes','No');
        close(f201)
        if choice==2
            continue
        end
        
       %-check which recordings to include in IF curve (i.e. currents the neuron could continously follow):-
       f201=figure(201); 
       for j=size(data{1,i},2):-1:1
            plot(data{1,i}(:,j)*1000,'k')
            lastIFmenu = menu('Include in IF curve?','Yes','No');
            if lastIFmenu==1
                lastIF_trace=j;
                break
            else
                lastIF_trace=size(data{1,i},2);
            end
        end       
        close(f201)

        %
        % -set threshold and extract peaks and locations of spikes in each longIV trace:-
        f200=figure(200);
        
        if size(data{1,i},2)>1                                  
            plot(data{1,i}(:,lastIF_trace)) 
            title('long IV data');
        
            
            threshold=imline(gca,[0 size(data{1,i},1)],[0.01 0.01]);
            setColor(threshold,'g');
            borderfcn_x_constrains=makeConstrainToRectFcn('imline',[0 size(data{1,i},1)],[-100 100]);
            setPositionConstraintFcn(threshold, borderfcn_x_constrains);
            position_t = wait(threshold);
            position_threshold=threshold.getPosition();
            threshold=position_threshold(1,2);
            close (f200)
            for j=1:lastIF_trace
                clearvars pks locs
                [pks,locs]=findpeaks(data{1,i}(pretrigger_time*samplingrates{1,i}:...
                    pretrigger_time*samplingrates{1,i}+longIV_time*samplingrates{1,i},j));
                locs(pks<threshold)=0;
                locs(locs==0)=[];
                pks(pks<threshold)=0;
                pks(pks==0)=[];

                IF_peaks{1,j}=pks;
                IF_locs{1,j}=locs;
                
                %-calculate dAmplitude between first and last spike in
                %longIV protocol
                if j==lastIF_trace
                    mean_resting_pot=mean(data{1,i}(1:pretrigger_time*samplingrates{1,i},j));
                    height_firstspike=IF_peaks{1,j}(1,1)+abs(mean_resting_pot);
                    height_lastspike=IF_peaks{1,j}(end,1)+abs(mean_resting_pot);
                    delta_amplitude_firstspike_lastspike=height_firstspike-height_lastspike;
                    normalized_delta_amplitude_firstspike_lastspike=1-height_lastspike/height_firstspike;
                end
            end
                

            %-calculate intespike intervals, discard intervals smaller than 1.5 ms:-
            for j=1:lastIF_trace
                clearvars f_calc_isis
                f_calc_isis=diff(IF_locs{1,j});
                f_calc_isis(f_calc_isis<(1.5*10^-3)*samplingrates{1,i})=[];
                
                
                if isempty(f_calc_isis)
                    mean_freq(j)=NaN;
                    std_freq(j)=NaN;
                    IF_current(j)=NaN;
                elseif ~isempty(f_calc_isis)
                    f_calc_isis=f_calc_isis./samplingrates{1,i};
                    freqs=1./f_calc_isis;
                    mean_freq(j)=mean(freqs);
                    std_freq(j)=std(freqs);
                    IF_current(j)=effective_basis_current+((j-1)*longIV_amplitude);
                end
            end
        end
       %--end of IF_curve value extraction--

       %--plot IV and IF curves--
        f1=figure (i);
        set(f1, 'Units', 'normalized', 'Position', [0, 0, 1, 1]); 
        f1_x_axis=0:1/samplingrates{1,i}:size(data{1,i},1)/samplingrates{1,i};
        f1_x_axis=f1_x_axis(1:end-1);
        
        f_1_1=subplot(4,4,[1,2,5,6,9,10,13,14]);
        hold on
        testcount=0;
        

        for j=lastIF_trace:-1:1
            mean_resting_pot=mean(data{1,i}(1:pretrigger_time*samplingrates{1,i},j));
            mean_stimulusdrop(1,j)=mean(data{1,i}((pretrigger_time+longIV_time-0.3)*samplingrates{1,i}:...
                                              (pretrigger_time+longIV_time)*samplingrates{1,i},j));
            

            if j==1
                plot(f1_x_axis, data{1,i}(:,j)*1000,'k') %only displays data in mV, no change to data
                deltaV_longIV(1,j)=mean_stimulusdrop(1,j)-mean_resting_pot;
                applied_current_longIV_forfit(1,j)=effective_basis_current+((j-1)*longIV_amplitude);
                applied_current_longIV_allsteps(1,j)=effective_basis_current+((j-1)*longIV_amplitude);
                plot(f1_x_axis,mean_stimulusdrop(1,j)*ones(round(size(f1_x_axis,2)),1)*1000,'r--','LineWidth',1.5)
                testcount=testcount+1;
            elseif j > 1 && max(data{1,i}(pretrigger_time*samplingrates{1,i}:...
                            (pretrigger_time+longIV_time)*samplingrates{1,i},j))...
                            < threshold
                        
                plot(f1_x_axis, data{1,i}(:,j)*1000,'k') %only displays data in mV, no change to data
                deltaV_longIV(1,j)=mean_stimulusdrop(1,j)-mean_resting_pot;
                applied_current_longIV_forfit(1,j)=effective_basis_current+((j-1)*longIV_amplitude);
                applied_current_longIV_allsteps(1,j)=effective_basis_current+((j-1)*longIV_amplitude);
                plot(f1_x_axis,mean_stimulusdrop(1,j)*ones(round(size(f1_x_axis,2)),1)*1000,'r--','LineWidth',1.5)
                testcount=testcount+1;
            elseif j > 1 && max(data{1,i}(pretrigger_time*samplingrates{1,i}:...
                            (pretrigger_time+longIV_time)*samplingrates{1,i},j))...
                            > threshold
                applied_current_longIV_allsteps(1,j)=effective_basis_current+((j-1)*longIV_amplitude);        
                plot(f1_x_axis, data{1,i}(:,j)*1000,'color',[0,0,0]+0.6)
                %break
            end

        end
        
      
        hold off
                
        title([save_filename,' ,longIV Stimulus, ',longIV_parameters{2,1},' pA-steps, ' ,num2str(size(data{1,i},2)),' repetitions'],'interpreter','none'); 
        xlabel(['Time [s]']);
        ylabel(['Potential [mV]']);
        
        subplot(4,4,[3,7])
        %--linfit for I-V curve:-- 
        linreg_longIV=fitlm(applied_current_longIV_forfit,deltaV_longIV,'intercept',false);
        linreg_longIV_vals=linreg_longIV.Fitted;
        linreg_longIV_input_res=linreg_longIV.Coefficients{1,1};
        rms=linreg_longIV.Rsquared.Ordinary;
        rms_error=linreg_longIV.RMSE;
        
        plot(applied_current_longIV_forfit*10^12,deltaV_longIV*1000,'ro')
        hold on
         plot(applied_current_longIV_forfit*10^12,linreg_longIV_vals*1000,'b')
        title(['I-U curve ' filename],'interpreter','none'); 
        xlabel(['Applied current [pA]']);
        ylabel(['DeltaV [mV]']);
        
        
        %--resultswindow:--
        results_window_text=sprintf(['LongIV #',num2str(longIV),', applied as protocol #',num2str(i)...
                '\n\nInput res. from regression (slope): ' num2str(linreg_longIV_input_res*10^-6),' MOhm'...
                '\nRMS: ', num2str(rms),...
                '\nRMSE: ',num2str(rms_error)...
                '\nHolding current: ', num2str(holding_current*10^12),' pA']);

        dim1 = [.55 .18 .3 .3];
        annotation('textbox',dim1,'String',results_window_text,'FitBoxToText','on',...
                    'FontSize',9,'FontWeight','bold','horizontalAlignment', 'left');
        hold off
        
       
        if exist('IF_current')==1 && nansum(IF_current)~= 0
        
        %--plot I-F curve:--    
        subplot(4,4,[4,8])
        hold on
        
        plot(IF_current*10^12,mean_freq,'ro')
        hold on


        title(['I-F curve ' filename],'interpreter','none'); 
        xlabel(['Applied current [pA]']);
        ylabel(['Mean Frequency [Hz]']);
        
        hold off
        end
        
        %--plot Stimuli--
        subplot(4,4,[15,16])
        hold on
        x_axis_stimulus=0:1/samplingrates{1,i}:size(stimulus_trace,2)/samplingrates{1,i};
        x_axis_stimulus=x_axis_stimulus(1:end-1);
        
        
        for z=1:size(applied_current_longIV_allsteps,2)
            plot(x_axis_stimulus,applied_current_longIV_allsteps(z)*stimulus_trace*10^12,'b')
        end
        ylim([min(applied_current_longIV_allsteps*10^12)-longIV_amplitude*10^12,...
            max(applied_current_longIV_allsteps*10^12)+longIV_amplitude*10^12]);
        title('LongIV Stimulus');
        xlabel(['Time [s]']);
        ylabel(['Applied current [pA]']);
        hold off

        
        %--save extracted data:--
        savedlg=menu('Save figure and results?','Yes','No');
        
        if savedlg==1
        parameternames={};
        parameternames={'Input_res_OHM','RMS','RMSE','Holding_current_A','IF_current_A','mean_freq_IF','std_freq_IF','amplitude_drop_longIV','amplitude_drop_longIV_normalized'}';
        

        parametervalues={};
        parametervalues={linreg_longIV_input_res,rms,rms_error, holding_current,IF_current,mean_freq,std_freq,delta_amplitude_firstspike_lastspike,normalized_delta_amplitude_firstspike_lastspike}';                    
        
            for j=1:size(parameternames,1)
                results.(['results_' save_filename]).(['Prot_no_' num2str(i) '_' longIVname]).(parameternames{j,1})...
                        ={parametervalues{j,1},2};

            end
        rawdata.(['rawdata_' save_filename]).(['Prot_no_' num2str(i) '_' longIVname '_rawdata'])=data{1,i};
        stimulusdata.(['stimulusdata_' save_filename]).(['Prot_no_' num2str(i) '_' longIVname '_stimulusdata']).longIV_amplitudes=applied_current_longIV_allsteps;
        stimulusdata.(['stimulusdata_' save_filename]).(['Prot_no_' num2str(i) '_' longIVname '_stimulusdata']).longIV_length=longIV_time;
        stimulusdata.(['stimulusdata_' save_filename]).(['Prot_no_' num2str(i) '_' longIVname '_stimulusdata']).longIV_pretrigger=pretrigger_time;
        stimulusdata.(['stimulusdata_' save_filename]).(['Prot_no_' num2str(i) '_' longIVname '_stimulusdata']).samplingfrequency=samplingrates{1,i};
        
        saveas(f1,['figs\' filename '_' longIVname '_prot_no_' num2str(i)])

        set(f1, 'PaperUnits', 'normalized');
        set(f1, 'PaperPosition', [0 0.1 1 .7]); 

        saveas(f1,['jpgs\' filename '_' longIVname '_prot_no_' num2str(i)],'jpg')
 

        end
        
    elseif strcmp(protocol{1,i},test_IV1name)
        %%
        test_IV1=test_IV1+1;
        %define test_IV1 parameters:
        %--input prompt--
        test_IV1_inputs = {'Number of Sweeps','Increment per step [pA]','Pretrigger time [s]', 'Step time [s]',...
                  'Posttrigger time [s]'};
        prompt_title = 'test_IV1 parameters';
        dims = [1 45];
        default_input = {num2str(size(data{1,i},2)),num2str(patchmaster_data.(structname{1,1}).stimTree{1,i}{4,3}.seDeltaVIncrement*1000),...
                    num2str(patchmaster_data.(structname{1,1}).stimTree{1,i}{3,3}.seDuration)...
                    num2str(patchmaster_data.(structname{1,1}).stimTree{1,i}{4,3}.seDuration),...
                    num2str(patchmaster_data.(structname{1,1}).stimTree{1,i}{5,3}.seDuration)};
        test_IV1_parameters = inputdlg(test_IV1_inputs,prompt_title,dims,default_input);
        %--variable assignment--
        holding_current=patchmaster_data.(structname{1,1}).stimTree{1,i}{2,2}.chHolding*10^-9;    % in ampere
        number_of_sweeps=str2num(test_IV1_parameters{1,1});
        test_IV1_amplitude=str2num(test_IV1_parameters{2,1})*10^-12;                              % in ampere
        pretrigger_time=str2num(test_IV1_parameters{3,1});                                        % in seconds
        test_IV1_time=str2num(test_IV1_parameters{4,1});                                          % in seconds
        posttrigger_time=str2num(test_IV1_parameters{5,1});                                       % in seconds
        effective_basis_current=(patchmaster_data.(structname{1,1}).stimTree{1,i}{4,3}.seVoltage-...
                      patchmaster_data.(structname{1,1}).stimTree{1,i}{2,2}.chHolding)*10^-9;     % in ampere
                  
        stimulus_trace=horzcat(zeros(1,round(pretrigger_time*samplingrates{1,i})),...
                               zeros(1,round(test_IV1_time*samplingrates{1,i})),...
                               zeros(1,round(posttrigger_time*samplingrates{1,i})))  ; 
        stimulus_trace(pretrigger_time*samplingrates{1,i}+1:pretrigger_time*...
                        samplingrates{1,i}+test_IV1_time*samplingrates{1,i})=1; 
        
        %--plot recordings and extract those in which spikes occured:--
        f1=figure (i);
        set(f1, 'Units', 'normalized', 'Position', [0, 0, 1, 1]); 
        f1_x_axis=0:1/samplingrates{1,i}:size(data{1,i},1)/samplingrates{1,i};
        f1_x_axis=f1_x_axis(1:end-1);            
                    
        f_1_1=subplot(4,4,[1,2,5,6,9,10,13,14]);
        hold on
        first_spike_detected=0;
        
        %--spike extraction:--
        for j=1:size(data{1,i},2)
            mean_resting_pot=mean(data{1,i}(1:pretrigger_time*samplingrates{1,i},j));
            mean_stimulusdrop(1,j)=mean(data{1,i}((pretrigger_time+test_IV1_time-0.3)*samplingrates{1,i}:...
                                              (pretrigger_time+test_IV1_time)*samplingrates{1,i},j));

            if abs(max(data{1,i}(pretrigger_time*samplingrates{1,i}:...
                            (pretrigger_time+test_IV1_time)*samplingrates{1,i},j))-mean_resting_pot)...
                            < abs(2*(mean_stimulusdrop(1,j)-mean_resting_pot))
                        
                spiking(1,j)=0;        
            elseif abs(max(data{1,i}(pretrigger_time*samplingrates{1,i}:...
                            (pretrigger_time+test_IV1_time)*samplingrates{1,i},j))-mean_resting_pot)...
                            > abs(2*(mean_stimulusdrop(1,j)-mean_resting_pot))
                spiking(1,j)=1; 
            end
        end
        
       %%
        
        %--plot traces. Subthreshold:black; threshold:red;
        %suprathreshold:grey; spiketraces which were folllowed by
        %nonspike-traces at higher stimulation (i.e. spikes due to synaptic
        %input): orange--
        %-sort traces:--
        for j=1:size(data{1,i},2)

            if spiking(1,j)==0 
                        
                plot(f1_x_axis, data{1,i}(:,j)*1000,'k') %only displays data in mV, no change to data
                applied_current_test_IV1(1,j)=effective_basis_current+((j-1)*test_IV1_amplitude);
               
                
            elseif spiking(1,j)==1 && sum(spiking(1,j:end)) == length(spiking)+1-j && first_spike_detected==0
                
                red_curve=data{1,i}(:,j);
                first_spike_detected=1;
                applied_current_test_IV1(1,j)=effective_basis_current+((j-1)*test_IV1_amplitude);
                rheo_sweep=j;
                rheobase=effective_basis_current+((j-1)*test_IV1_amplitude);

                
            elseif spiking(1,j)==1 && sum(spiking(1,j:end)) == length(spiking)+1-j && first_spike_detected==1
                        
                plot(f1_x_axis, data{1,i}(:,j)*1000,'color',[0,0,0]+0.6)
                applied_current_test_IV1(1,j)=effective_basis_current+((j-1)*test_IV1_amplitude);
            else
                
                plot(f1_x_axis, data{1,i}(:,j)*1000,'color',[255,127,0]./255)
                applied_current_test_IV1(1,j)=effective_basis_current+((j-1)*test_IV1_amplitude);
                
            end   
        end
        
        if first_spike_detected==1
            plot(f1_x_axis, red_curve*1000,'r') %only displays data in mV, no change to data
        end
        hold off

        %--plot rheobase trace--
        title([save_filename,' ,test IV1 Stimulus, ',test_IV1_parameters{2,1},' pA-steps, ' ,num2str(size(data{1,i},2)),' repetitions'],'interpreter','none'); 
        xlabel(['Time [s]']);
        ylabel(['Potential [mV]']);
        
        if first_spike_detected==1
            subplot(4,4,[3,4,7,8])
            plot(f1_x_axis, data{1,i}*1000,'color',[0,0,0]+0.75)
            hold on
            plot(f1_x_axis, red_curve*1000,'r')
            mean_resting_rheo=mean(red_curve(1:pretrigger_time*samplingrates{1,i}));
            plot(f1_x_axis, 1000*mean_resting_rheo*ones(1,length(f1_x_axis)),'k--','LineWidth',1.5)
            xlabel(['Time [s]']);
            ylabel(['Potential [mV]']);
            title('AP at Rheobase');
            msg_message=sprintf(['Please use right window to choose a coordinate as follows: '...
                                '\nX-axis: Timepoint after first, but before second spike'...
                                '\nY-axis: Align horizontal cursor with voltage threshold']);
            waitfor(msgbox(msg_message));

            
            [spikeoccurancewindow_limit,v_threshold]=ginput(1);
            v_threshold=v_threshold/1000;

            spikepeak_rheo=max(red_curve(1:spikeoccurancewindow_limit*samplingrates{1,i}));
            spikeheight_rheo_fromresting=spikepeak_rheo-mean_resting_rheo;
            spikeheight_rheo_fromv_thres=spikepeak_rheo-v_threshold;
            
            for j=1:round(spikeoccurancewindow_limit*samplingrates{1,i})
                if red_curve(j)==spikepeak_rheo
                    time_rheo_AP=j/samplingrates{1,i};
                end
            end
       rel_time_rheo_AP=time_rheo_AP-pretrigger_time;
       plot([time_rheo_AP-0.05,time_rheo_AP-0.05],[mean_resting_rheo*1000,(spikeheight_rheo_fromresting+mean_resting_rheo)*1000],'b*-')
       plot([time_rheo_AP+0.05,time_rheo_AP+0.05],[v_threshold*1000,(spikeheight_rheo_fromresting+mean_resting_rheo)*1000],'g*-')
       plot(f1_x_axis, 1000*v_threshold*ones(1,length(f1_x_axis)),'k--','LineWidth',1.5)
       hold off
       
       %--plot results window in figure:--
       results_window_text=sprintf(['Test IV1 #',num2str(test_IV1),', applied as protocol #',num2str(i)...
            '\n\nRheobase: ',num2str(rheobase*10^12),' pA'...
            '\nRheobase-AP amplitude from resting: ', num2str(spikeheight_rheo_fromresting*1000),' mV'...
            '\nRheobase-AP amplitude from voltage threshold: ', num2str(spikeheight_rheo_fromv_thres*1000),' mV'...
            '\nRheobase-AP latency: ',num2str(rel_time_rheo_AP*10^3),' ms'...
            '\nHolding current: ', num2str(holding_current*10^12),' pA']);

        dim1 = [.55 .18 .3 .3];
        annotation('textbox',dim1,'String',results_window_text,'FitBoxToText','on',...
                    'FontSize',9,'FontWeight','bold','horizontalAlignment', 'left');
            
        %--plot stimulus traces:--
        subplot(4,4,[15,16])
        hold on
        x_axis_stimulus=0:1/samplingrates{1,i}:size(stimulus_trace,2)/samplingrates{1,i};
        x_axis_stimulus=x_axis_stimulus(1:end-1);
        
        
        for z=1:size(applied_current_test_IV1,2)
            plot(x_axis_stimulus,applied_current_test_IV1(z)*stimulus_trace*10^12,'b')
        end
        plot(x_axis_stimulus,applied_current_test_IV1(rheo_sweep)*stimulus_trace*10^12,'r')
        if test_IV1_amplitude~=0
        ylim([min(applied_current_test_IV1*10^12)-test_IV1_amplitude*10^12,...
            max(applied_current_test_IV1*10^12)+test_IV1_amplitude*10^12]);
        end
        title('test IV1 Stimulus');
        xlabel(['Time [s]']);
        ylabel(['Applied current [pA]']);
        hold off
                
                
        else
            results_window_text=sprintf(['Rheobase calculation'...
                                           '\nnot possible']);

            dim1 = [.55 .18 .3 .3];
            annotation('textbox',dim1,'String',results_window_text,'FitBoxToText','on',...
                        'FontSize',12,'FontWeight','bold','horizontalAlignment', 'center');
        end

        %%
        
        %--save extracted data:--
        savedlg=menu('Save figure and results?','Yes','No');
        
        if savedlg==1
        parameternames={};
        parameternames={'Rheobase_A','AP_amp_from_resting_V','AP_amp_from_thres_V','AP_latency_s','Holding_current_A'}';
        

        parametervalues=[];
        parametervalues=[rheobase,spikeheight_rheo_fromresting,spikeheight_rheo_fromv_thres, rel_time_rheo_AP, holding_current]';                    
        
            for j=1:size(parameternames,1)
                results.(['results_' save_filename]).(['Prot_no_' num2str(i) '_' test_IV1name]).(parameternames{j,1})...
                        ={parametervalues(j,1),3};

            end
        
        rawdata.(['rawdata_' save_filename]).(['Prot_no_' num2str(i) '_' test_IV1name '_rawdata'])=data{1,i};    
        stimulusdata.(['stimulusdata_' save_filename]).(['Prot_no_' num2str(i) '_' test_IV1name '_stimulusdata']).test_IV1_amplitudes=applied_current_test_IV1; 
        stimulusdata.(['stimulusdata_' save_filename]).(['Prot_no_' num2str(i) '_' test_IV1name '_stimulusdata']).test_IV1_pretrigger_time=pretrigger_time;
        stimulusdata.(['stimulusdata_' save_filename]).(['Prot_no_' num2str(i) '_' test_IV1name '_stimulusdata']).test_IV1_length=test_IV1_time;
        stimulusdata.(['stimulusdata_' save_filename]).(['Prot_no_' num2str(i) '_' test_IV1name '_stimulusdata']).samplingrate=samplingrates{1,i};
        saveas(f1,['figs\' filename '_' test_IV1name '_prot_no_' num2str(i)])

            set(f1, 'PaperUnits', 'normalized');
            set(f1, 'PaperPosition', [0 0.1 1 .7]); 
        saveas(f1,['jpgs\' filename '_' test_IV1name '_prot_no_' num2str(i)],'jpg')
        end
                    
    elseif strcmp(protocol{1,i},const_ccname)
        %% NOT USED

    elseif strcmp(protocol{1,i},rampIVname)
        %%
        rampIV=rampIV+1;
        
        %--analyse dataset?--
        f201=figure(201);
        plot(data{1,i});
        title('RampIV data');
        choice = menu('Analyse data?','Yes','No');
        if choice==2
            continue
        end
        close(f201);
        %define rampIV parameters:
        %--input prompt--
        rampIV_inputs = {'Number of Sweeps','Increment per step [pA]','Pretrigger time [s]', 'Ramp rise time [s]',...
                 'Ramp fall time [ms]' 'Posttrigger time [s]'};
        prompt_title = 'rampIV parameters';
        dims = [1 45];
        default_input = {num2str(size(data{1,i},2)),num2str(patchmaster_data.(structname{1,1}).stimTree{1,i}{4,3}.seDeltaVIncrement*1000),...
                    num2str(patchmaster_data.(structname{1,1}).stimTree{1,i}{3,3}.seDuration),...
                    num2str(patchmaster_data.(structname{1,1}).stimTree{1,i}{4,3}.seDuration),...
                    num2str(patchmaster_data.(structname{1,1}).stimTree{1,i}{5,3}.seDuration),...
                    num2str(patchmaster_data.(structname{1,1}).stimTree{1,i}{6,3}.seDuration)};
        rampIV_parameters = inputdlg(rampIV_inputs,prompt_title,dims,default_input);
        %--variable assignment--
        holding_current=patchmaster_data.(structname{1,1}).stimTree{1,i}{2,2}.chHolding*10^-9;    % in ampere
        number_of_sweeps=str2num(rampIV_parameters{1,1});
        rampIV_amplitude=str2num(rampIV_parameters{2,1})*10^-12;                              % in ampere
        pretrigger_time=str2num(rampIV_parameters{3,1});                                      % in seconds
        rampIV_time=str2num(rampIV_parameters{4,1});                                          % in seconds
        rampIV_fall_time=str2num(rampIV_parameters{5,1});                                     % in seconds
        posttrigger_time=str2num(rampIV_parameters{6,1});                                     % in seconds
        effective_basis_current=(patchmaster_data.(structname{1,1}).stimTree{1,i}{4,3}.seVoltage-...
                      patchmaster_data.(structname{1,1}).stimTree{1,i}{2,2}.chHolding)*10^-9; % in ampere
                  
        stimulus_trace=horzcat(zeros(1,round(pretrigger_time*samplingrates{1,i})),...
                               zeros(1,round(rampIV_time*samplingrates{1,i})),...
                               zeros(1,round(posttrigger_time*samplingrates{1,i})))  ; 
        stimulus_trace(pretrigger_time*samplingrates{1,i}+1:pretrigger_time*...
                        samplingrates{1,i}+rampIV_time*samplingrates{1,i})=...
                        0:1/((pretrigger_time*samplingrates{1,i}+rampIV_time*samplingrates{1,i}-pretrigger_time*samplingrates{1,i})-1):1;
                
        stimulus_trace(pretrigger_time*samplingrates{1,i}+rampIV_time*samplingrates{1,i}+1:...
                        pretrigger_time*samplingrates{1,i}+rampIV_time*samplingrates{1,i}+rampIV_fall_time*samplingrates{1,i})=...
                        1:-1/(length(pretrigger_time*samplingrates{1,i}+rampIV_time*samplingrates{1,i}+1:...
                        pretrigger_time*samplingrates{1,i}+rampIV_time*samplingrates{1,i}+rampIV_fall_time*samplingrates{1,i})-1):0;
        
                    
                    
        f1_x_axis=0:1/samplingrates{1,i}:size(data{1,i},1)/samplingrates{1,i};
        f1_x_axis=f1_x_axis(1:end-1); 
        
        %--set threshold for spike analysis:--
        f100=figure(100);
        plot(f1_x_axis((pretrigger_time-0.005)*samplingrates{1,i}:(pretrigger_time+0.01)*samplingrates{1,i}),data{1,i}((pretrigger_time-0.005)*samplingrates{1,i}:(pretrigger_time+0.01)*samplingrates{1,i},:)*1000)
        xlim([f1_x_axis(floor((pretrigger_time-0.005)*samplingrates{1,i})) f1_x_axis(floor((pretrigger_time+0.01)*samplingrates{1,i}))])
        plotsection_rampIV=(pretrigger_time-0.005)*samplingrates{1,i}:(pretrigger_time+0.03)*samplingrates{1,i};
        
        msg = msgbox('Please define supra-threshold area (drag green line to a supra-threshold level an doubleclick it)');
        spikethres=imline(gca,[f1_x_axis(floor((pretrigger_time-0.005)*samplingrates{1,i})) f1_x_axis(floor((pretrigger_time+0.01)*samplingrates{1,i}))],[.5 .5]);
        setColor(spikethres,'g');
        borderfcn_x_constrains=makeConstrainToRectFcn('imline',[f1_x_axis(floor((pretrigger_time-0.005)*samplingrates{1,i})) f1_x_axis(floor((pretrigger_time+0.01)*samplingrates{1,i}))],[-100 200]);
        setPositionConstraintFcn(spikethres, borderfcn_x_constrains);
        position_l = wait(spikethres);
        position_spikethres=spikethres.getPosition();
        spikethres=position_spikethres(1,2)/1000;
        close(f100);
        
        %--sort traces in subtreshhold and suprathreshold traces:--
        f1=figure (i);
        set(f1, 'Units', 'normalized', 'Position', [0, 0, 1, 1]); 
                   
                    
        f_1_1=subplot(4,4,[1,2,5,6,9,10,13,14]);
        hold on
        first_spike_detected=0;
        
        for j=1:size(data{1,i},2)
            mean_resting_pot=mean(data{1,i}(1:pretrigger_time*samplingrates{1,i},j));


            if max(data{1,i}(:,j)) < spikethres
                spiking(1,j)=0;
                
            elseif max(data{1,i}(:,j)) > spikethres
                spiking(1,j)=1; 
            end
        end
        
        %--plot traces:-- 
        for j=1:size(data{1,i},2)

            if spiking(1,j)==0 
                        
                plot(f1_x_axis(round(plotsection_rampIV)), data{1,i}(round(plotsection_rampIV),j)*1000,'color',[0,0,0]+0.6) %only displays data in mV, no change to data
                applied_current_rampIV(1,j)=effective_basis_current+((j-1)*rampIV_amplitude);
                
            elseif spiking(1,j)==1 && sum(spiking(1,j:end)) == length(spiking)+1-j && first_spike_detected==0
                
                red_curve=data{1,i}(:,j);
                if j>1
                subtract_curve=data{1,i}(:,j-1);
                calculated_curve=red_curve-subtract_curve;
                first_spike_detected=1;
                applied_current_rampIV(1,j)=effective_basis_current+((j-1)*rampIV_amplitude);
                effective_sweep=j;
                trig_current=effective_basis_current+((j-1)*rampIV_amplitude);
                else
                results_window_text=sprintf(['calculation not possible'...
                                           '\nspike on first stimulation']);

                dim1 = [.55 .18 .3 .3];
                annotation('textbox',dim1,'String',results_window_text,'FitBoxToText','on',...
                        'FontSize',12,'FontWeight','bold','horizontalAlignment', 'center');
                    continue
                    
                end
                
            elseif spiking(1,j)==1 && sum(spiking(1,j:end)) == length(spiking)+1-j && first_spike_detected==1
                        
                plot(f1_x_axis(round(plotsection_rampIV)), data{1,i}(round(plotsection_rampIV),j)*1000,'color',[0,0,0]+0.6)
                applied_current_rampIV(1,j)=effective_basis_current+((j-1)*rampIV_amplitude);
            else
                %if first spike was detected but not each
                %stimulation after first spike provoked another spike (=plot trace in orange):
                plot(f1_x_axis(round(plotsection_rampIV)), data{1,i}(round(plotsection_rampIV),j)*1000,'color',[255,127,0]./255)
                applied_current_rampIV(1,j)=effective_basis_current+((j-1)*rampIV_amplitude);
                
            end   
        end
        
        if first_spike_detected==1
            plot(f1_x_axis(round(plotsection_rampIV)), red_curve(round(plotsection_rampIV))*1000,'r','LineWidth',1.5) %only displays data in mV, no change to data
            plot(f1_x_axis(round(plotsection_rampIV)), subtract_curve(round(plotsection_rampIV))*1000,'g','LineWidth',1.5)
        end

        hold off
        
        title([save_filename,' ,Ramp IV Stimulus, ',rampIV_parameters{2,1},' pA-steps, ' ,num2str(size(data{1,i},2)),' repetitions'],'interpreter','none'); 
        xlabel(['Time [s]']);
        ylabel(['Potential [mV]']);
        
        %--plot calculated rampIV spike (firstspike trace -last
        %subthreshold trace)and extract spike parameters (i.e. FWHM and height of AP and AHP)
        if first_spike_detected==1
            subplot(4,4,[3,7]) 
            hold on
            plot(f1_x_axis(round(plotsection_rampIV)), calculated_curve(round(plotsection_rampIV))*1000,'b')
            
            mean_resting_calculated=mean(calculated_curve(1:pretrigger_time*samplingrates{1,i}));
            plot(f1_x_axis(round(plotsection_rampIV)), 1000*mean_resting_calculated*ones(1,length(f1_x_axis(round(plotsection_rampIV)))),'k--','LineWidth',1.5)
            title('Calculated AP (Red-Green)');
            xlabel(['Time [s]']);
            ylabel(['Potential [mV]']);

            
            [spikepeak_triggered,time_AP1]=max(calculated_curve);
            spikeheight_triggered_fromresting=spikepeak_triggered-mean_resting_calculated;
            [ahppeak_triggered,timeAHP]=min(calculated_curve);
            ahpheight_triggered_fromresting=ahppeak_triggered-mean_resting_calculated;
           
            
            for j=1:length(calculated_curve)                            
                if calculated_curve(j)==spikepeak_triggered
                    time_triggered_AP=j/samplingrates{1,i};
                elseif calculated_curve(j)== ahppeak_triggered
                    time_triggered_AHP=j/samplingrates{1,i};
                end
            end
            %-extract AP-FWHM for sub-threshold subtracted spike:-
            for j=2:length(calculated_curve)
                if calculated_curve(j)>=0.5*spikepeak_triggered && calculated_curve(j-1)<0.5*spikepeak_triggered
                    FWHM_vals(1,1)=j;
                    
                elseif calculated_curve(j)<=0.5*spikepeak_triggered && calculated_curve(j-1)>0.5*spikepeak_triggered
                    FWHM_vals(1,2)=j;
                    
                end
            end
            %-extract AHP-FWHM for sub-threshold subtracted spike:-
            for j=2:length(calculated_curve)
                if calculated_curve(j)<=0.5*ahppeak_triggered && calculated_curve(j-1)>0.5*ahppeak_triggered...
                        && j < time_triggered_AHP*samplingrates{1,i} && j> time_triggered_AP*samplingrates{1,i}
                    AHP_FWHM_vals(1,1)=j;
                    
                elseif calculated_curve(j)>=0.5*ahppeak_triggered && calculated_curve(j-1)<0.5*ahppeak_triggered...
                        && j > time_triggered_AHP*samplingrates{1,i}
                    AHP_FWHM_vals(1,2)=j;
                end
            end
            
       FWHM=(FWHM_vals(1,2)-FWHM_vals(1,1))/samplingrates{1,i};
       AHP_FWHM=(AHP_FWHM_vals(1,2)-AHP_FWHM_vals(1,1))/samplingrates{1,i};
       rel_time_triggered_AP=time_triggered_AP-pretrigger_time;
       rel_time_triggered_AHP=time_triggered_AHP-pretrigger_time;
       
       %-plot AP- and AHP-heights plus AP- and AHP FWHMs for sub-threshold subtracted spike:-
       plot([time_triggered_AP-0.002,time_triggered_AP-0.002],[mean_resting_calculated*1000,(spikeheight_triggered_fromresting+mean_resting_calculated)*1000],'b*-')
       plot([time_triggered_AHP+0.002,time_triggered_AHP+0.002],[mean_resting_calculated*1000,(ahpheight_triggered_fromresting+mean_resting_calculated)*1000],'g*-')
       
       plot([FWHM_vals(1,1)/samplingrates{1,i} FWHM_vals(1,2)/samplingrates{1,i}],[0.5*spikepeak_triggered*1000 0.5*spikepeak_triggered*1000], 'm*-')
       plot([AHP_FWHM_vals(1,1)/samplingrates{1,i} AHP_FWHM_vals(1,2)/samplingrates{1,i}],[0.5*ahppeak_triggered*1000 0.5*ahppeak_triggered*1000], 'm*-')
       
       xlim([round(plotsection_rampIV(1,1))/samplingrates{1,i} round(plotsection_rampIV(end))/samplingrates{1,i}])
       hold off
       results_window_text=sprintf(['Ramp IV #',num2str(rampIV),', applied as protocol #',num2str(i)...
            '\n\nTriggercurrent: ',num2str(trig_current*10^12),' pA'...
            '\nAP-amplitude from calculated: ', num2str(spikeheight_triggered_fromresting*1000),' mV'...
            '\nAHP-amplitude from calculated: ', num2str(ahpheight_triggered_fromresting*1000),' mV'...
            '\nFWHM: ',num2str(FWHM*1000),' ms'...
            '\nAHP FWHM: ',num2str(AHP_FWHM*1000),' ms'...
            '\nHolding current: ', num2str(holding_current*10^12),' pA']);

        dim1 = [.55 .18 .3 .3];
        annotation('textbox',dim1,'String',results_window_text,'FitBoxToText','on',...
                    'FontSize',9,'FontWeight','bold','horizontalAlignment', 'left');
            
        %--extract and plot values for original, non- substracted data:--
        
         subplot(4,4,[4,8]) 
            
            hold on
            plot(f1_x_axis(round(plotsection_rampIV)), red_curve(round(plotsection_rampIV))*1000,'b')
            xlim([round(plotsection_rampIV(1,1))/samplingrates{1,i} round(plotsection_rampIV(end))/samplingrates{1,i}])
            dlg_zoom=menu('Zoom?','Ok');

            [x_AP_trig,y_AP_trig]=ginput(1);
            v_thres=y_AP_trig/1000;
            xlim([round(plotsection_rampIV(1,1))/samplingrates{1,i} round(plotsection_rampIV(end))/samplingrates{1,i}])
            ylim auto
            resting_plot=mean(red_curve(1:pretrigger_time*samplingrates{1,i}));
            
            plot(f1_x_axis(round(plotsection_rampIV)), 1000*v_thres*ones(1,length(f1_x_axis(round(plotsection_rampIV)))),'k--','LineWidth',1.5)
            plot(f1_x_axis(round(plotsection_rampIV)), 1000*resting_plot*ones(1,length(f1_x_axis(round(plotsection_rampIV)))),'k--','LineWidth',1.5)
            title('Original AP');
            xlabel(['Time [s]']);
            ylabel(['Potential [mV]']);


            [spikepeak_triggered,time_AP]=max(red_curve(x_AP_trig*samplingrates{1,i}:end)); 
            spikeheight_triggered_fromv_thres=spikepeak_triggered-v_thres;
            ahppeak_triggered=red_curve(floor(time_triggered_AHP*samplingrates{1,i}));
            ahpheight_triggered_from_resting2=ahppeak_triggered-resting_plot;
            
            
            
            for j=2:length(red_curve)
                if red_curve(j)>=v_thres+0.5*spikeheight_triggered_fromv_thres && red_curve(j-1)<v_thres+0.5*spikeheight_triggered_fromv_thres
                    FWHM2_vals(1,1)=j;
                    
                elseif red_curve(j)<=v_thres+0.5*spikeheight_triggered_fromv_thres && red_curve(j-1)>v_thres+0.5*spikeheight_triggered_fromv_thres
                    FWHM2_vals(1,2)=j;
                end
            end
            
       [max_postspike,time_max_postspike]=max(red_curve(time_triggered_AHP*samplingrates{1,i}:.2*samplingrates{1,i}));
       time_max_postspike=time_max_postspike+time_triggered_AHP*samplingrates{1,i};
       
            for j=2:length(red_curve)
                if red_curve(j)<=max_postspike-(0.5*(max_postspike-ahppeak_triggered)) && red_curve(j-1)>max_postspike-(0.5*(max_postspike-ahppeak_triggered))...
                        && j> time_AP
                    AHP_FWHM2_vals(1,1)=j;
                    
                elseif red_curve(j)>=max_postspike-(0.5*(max_postspike-ahppeak_triggered)) && red_curve(j-1)<max_postspike-(0.5*(max_postspike-ahppeak_triggered))...
                        && j> time_triggered_AHP*samplingrates{1,i}
                    AHP_FWHM2_vals(1,2)=j;
                    break
                end
            end
       
       FWHM2=(FWHM2_vals(1,2)-FWHM2_vals(1,1))/samplingrates{1,i};
       AHP_FWHM2=(AHP_FWHM2_vals(1,2)-AHP_FWHM2_vals(1,1))/samplingrates{1,i};
       rel_time_triggered_AP=time_triggered_AP-pretrigger_time;
       rel_time_triggered_AHP=time_triggered_AHP-pretrigger_time;
       
       plot([time_triggered_AP-0.002,time_triggered_AP-0.002],[v_thres*1000,(spikeheight_triggered_fromv_thres+v_thres)*1000],'b*-')
       plot([time_triggered_AHP+0.002,time_triggered_AHP+0.002],[resting_plot*1000,(ahpheight_triggered_from_resting2+resting_plot)*1000],'g*-')
       
       plot([FWHM2_vals(1,1)/samplingrates{1,i} FWHM2_vals(1,2)/samplingrates{1,i}],[(v_thres+0.5*spikeheight_triggered_fromv_thres)*1000 (v_thres+0.5*spikeheight_triggered_fromv_thres)*1000], 'm*-')
       plot([AHP_FWHM2_vals(1,1)/samplingrates{1,i} AHP_FWHM2_vals(1,2)/samplingrates{1,i}],[(max_postspike-(0.5*(max_postspike-ahppeak_triggered)))*1000 (max_postspike-(0.5*(max_postspike-ahppeak_triggered)))*1000], 'm*-')
       
       hold off
       results_window_text=sprintf(['Ramp IV #',num2str(rampIV),', applied as protocol #',num2str(i)...
            '\n\nTriggercurrent: ',num2str(trig_current*10^12),' pA'...
            '\nThreshold voltage: ',num2str(v_thres*1000),' mV'...
            '\nAP-amplitude from threshold: ', num2str(spikeheight_triggered_fromv_thres*1000),' mV'...
            '\nAHP-amplitude from resting: ', num2str(ahpheight_triggered_from_resting2*1000),' mV'...
            '\nFWHM: ',num2str(FWHM2*1000),' ms'...
            '\nAHP FWHM: ',num2str(AHP_FWHM2*1000),' ms'...
            '\nHolding current: ', num2str(holding_current*10^12),' pA']);

        dim1 = [.76 .18 .3 .3];
        annotation('textbox',dim1,'String',results_window_text,'FitBoxToText','on',...
                    'FontSize',9,'FontWeight','bold','horizontalAlignment', 'left');
        
        %--plot stimulus traces:--
        subplot(4,4,[15,16])
        hold on
        x_axis_stimulus=0:1/samplingrates{1,i}:size(stimulus_trace,2)/samplingrates{1,i};
        x_axis_stimulus=x_axis_stimulus(1:end-1);
        
        
        
        for z=1:size(applied_current_rampIV,2)
            plot(x_axis_stimulus(round(plotsection_rampIV)),applied_current_rampIV(z)*stimulus_trace(round(plotsection_rampIV))*10^12,'b')
        end
        plot(x_axis_stimulus(round(plotsection_rampIV)),applied_current_rampIV(effective_sweep)*stimulus_trace(round(plotsection_rampIV))*10^12,'r')
        ylim([min(applied_current_rampIV*10^12)-rampIV_amplitude*10^12,...
            max(applied_current_rampIV*10^12)+rampIV_amplitude*10^12]);
        xlim([plotsection_rampIV(1)/samplingrates{1,i} plotsection_rampIV(end)/samplingrates{1,i}])
        title('Ramp IV1 Stimulus');
        xlabel(['Time [s]']);
        ylabel(['Applied current [pA]']);
        hold off
                
                
        else
            results_window_text=sprintf(['Rheobase calculation'...
                                           '\nnot possible']);

            dim1 = [.55 .18 .3 .3];
            annotation('textbox',dim1,'String',results_window_text,'FitBoxToText','on',...
                        'FontSize',12,'FontWeight','bold','horizontalAlignment', 'center');
        
        
        end
       


        savedlg=menu('Save figure and results?','Yes','No');
        
        if savedlg==1
        parameternames={};


        parameternames={'AP_amp_from_calculated_V','AHP_amp_from_calculated_V','FWHM_calculated_s','AHP_FWHM_calculated_s',...
                        'Thres_voltage_V', 'AP_amp_from_thres_V','AHP_amp_from_resting_V','FWHM_original_s','AHP_FWHM_original_s'...
                        'Trigger_current_A','Holding_current_A'}';
        

        parametervalues=[];
        parametervalues=[spikeheight_triggered_fromresting,ahpheight_triggered_fromresting,FWHM,AHP_FWHM,...
                        v_thres,spikeheight_triggered_fromv_thres,ahpheight_triggered_from_resting2,FWHM2,AHP_FWHM2,...
                        trig_current,holding_current]';                    
        
            for j=1:size(parameternames,1)
                results.(['results_' save_filename]).(['Prot_no_' num2str(i) '_' rampIVname]).(parameternames{j,1})...
                        ={parametervalues(j,1),4};

            end
        
        rawdata.(['rawdata_' save_filename]).(['Prot_no_' num2str(i) '_' rampIVname '_rawdata'])=data{1,i};
        stimulusdata.(['stimulusdata_' save_filename]).(['Prot_no_' num2str(i) '_' rampIVname '_stimulusdata']).rampIV_amplitudes=applied_current_rampIV; 
        stimulusdata.(['stimulusdata_' save_filename]).(['Prot_no_' num2str(i) '_' rampIVname '_stimulusdata']).rampIV_pretrigger_time=pretrigger_time;
        stimulusdata.(['stimulusdata_' save_filename]).(['Prot_no_' num2str(i) '_' rampIVname '_stimulusdata']).rampIV_risetime=rampIV_time;
        stimulusdata.(['stimulusdata_' save_filename]).(['Prot_no_' num2str(i) '_' rampIVname '_stimulusdata']).rampIV_falltime=rampIV_fall_time;
        stimulusdata.(['stimulusdata_' save_filename]).(['Prot_no_' num2str(i) '_' rampIVname '_stimulusdata']).samplingrate=samplingrates{1,i};

        
        
        saveas(f1,['figs\' filename '_' rampIVname '_prot_no_' num2str(i)])

            set(f1, 'PaperUnits', 'normalized');
            set(f1, 'PaperPosition', [0 0.1 1 .7]); 
            
        saveas(f1,['jpgs\' filename '_' rampIVname '_prot_no_' num2str(i)],'jpg')
        end
    elseif strcmp(protocol{1,i},ramptimeIVname)
        %% NOT USED
      
    elseif strcmp(protocol{1,i},PPname)
        %% NOT USED

    elseif strcmp(protocol{1,i},Jittername)
        %%
        Jitter=Jitter+1;
        %define Jitter parameters:
        %--input prompt--
        Jitter_inputs = {'Number of Sweeps','Step Amplitude [pA]','Pretrigger time [s]', 'Step time [s]',...
                  'Posttrigger time [s]'};
        prompt_title = 'Jitter parameters';
        dims = [1 45];
        default_input = {num2str(size(data{1,i},2)),num2str(patchmaster_data.(structname{1,1}).stimTree{1,i}{4,3}.seVoltage*1000),...
                    num2str(patchmaster_data.(structname{1,1}).stimTree{1,i}{3,3}.seDuration)...
                    num2str(patchmaster_data.(structname{1,1}).stimTree{1,i}{4,3}.seDuration),...
                    num2str(patchmaster_data.(structname{1,1}).stimTree{1,i}{5,3}.seDuration)};
        Jitter_parameters = inputdlg(Jitter_inputs,prompt_title,dims,default_input);
        %--variable assignment--
        holding_current=patchmaster_data.(structname{1,1}).stimTree{1,i}{2,2}.chHolding*10^-9;    % in ampere
        number_of_sweeps=str2num(Jitter_parameters{1,1});
        Jitter_amplitude=str2num(Jitter_parameters{2,1})*10^-12;                                  % in ampere
        pretrigger_time=str2num(Jitter_parameters{3,1});                                          % in seconds
        Jitter_time=str2num(Jitter_parameters{4,1});                                              % in seconds
        posttrigger_time=str2num(Jitter_parameters{5,1});                                         % in seconds
        effective_basis_current=(patchmaster_data.(structname{1,1}).stimTree{1,i}{4,3}.seVoltage-...
                      patchmaster_data.(structname{1,1}).stimTree{1,i}{2,2}.chHolding)*10^-9;     % in ampere
                  
        stimulus_trace=horzcat(zeros(1,round(pretrigger_time*samplingrates{1,i})),...
                               zeros(1,round(Jitter_time*samplingrates{1,i})),...
                               zeros(1,round(posttrigger_time*samplingrates{1,i})))  ; 
        stimulus_trace(pretrigger_time*samplingrates{1,i}+1:pretrigger_time*...
                        samplingrates{1,i}+Jitter_time*samplingrates{1,i})=1; 
        current_step_jitter=patchmaster_data.(structname{1,1}).stimTree{1,i}{4,3}.seVoltage*10^-9; % in ampere
        
        f201=figure(201);
        plot(data{1,i}*1000)
        title('Jitter data');
        choice = menu('Analyse data?','Yes','No');
        close(f201)
        if choice==2
            continue
        end
        %--plot traces and set threshold for spike detection:--
        f1=figure (i);
        set(f1, 'Units', 'normalized', 'Position', [0, 0, 1, 1]); 
        f1_x_axis=0:1/samplingrates{1,i}:size(data{1,i},1)/samplingrates{1,i};
        f1_x_axis=f1_x_axis(1:end-1);            
                    
        f_1_1=subplot(4,4,[1,2,5,6]);

        
        plot(f1_x_axis,data{1,i}*1000)
        xlabel('Time [s]');
        ylabel('Potential [mV]');
        title([save_filename,' ,Jitter Stimulus, ','Current-Step: ',num2str(patchmaster_data.(structname{1,1}).stimTree{1,i}{4,3}.seVoltage*1000-holding_current*10^12)...
            ,' pA, ' ,num2str(size(data{1,i},2)),' repetitions'],'interpreter','none');
        xlim([0 f1_x_axis(end)])
        
        threshold=imline(gca,[0 f1_x_axis(end)],[10 10]);
        setColor(threshold,'g');
        borderfcn_x_constrains=makeConstrainToRectFcn('imline',[0 f1_x_axis(end)],[-100 100]);
        setPositionConstraintFcn(threshold, borderfcn_x_constrains);
        position_t = wait(threshold);
        position_threshold=threshold.getPosition();
        threshold=position_threshold(1,2)/1000;
        
        %--pull height and position of spikes that occured during stimulation:--
        for j=1:size(data{1,i},2)
            clearvars pks locs locs_abovethres
            [pks,locs]=findpeaks(data{1,i}(:,j));
            for k=1:size(pks,1)
                if pks(k,1)> threshold && locs(k,1)> pretrigger_time*samplingrates{1,i}...
                   && locs(k,1)< (pretrigger_time+Jitter_time)*samplingrates{1,i}          
                    locs_abovethres(k)=locs(k);
                    
                end
            end
            %--sort traces into spike- and nonspike-traces:--
            locscheck = exist ('locs_abovethres');
            if locscheck==1;
                locs_abovethres(locs_abovethres==0)=[];
                firstspike_loc(1,j)=locs_abovethres(1);
            else
                firstspike_loc(1,j)=NaN;
                nonspike_traces_jitter(1,j)=j;
            end
        end
        
        %--plot nonspike-traces and their mean:--
            if exist('nonspike_traces_jitter')
            nonspike_traces_jitter(nonspike_traces_jitter==0)=[];
            nonspike_traces_jitter_raw=data{1,i}(:,nonspike_traces_jitter);
            
            f_1_3=subplot(4,4,[9,10,13,14]);
            plot(f1_x_axis,nonspike_traces_jitter_raw*1000,'color',[0 0 0]+0.7)
            hold on
            plot(f1_x_axis,mean(nonspike_traces_jitter_raw,2)*1000,'r')
            title('Nonspike traces');
            xlabel('Time [s]');
            ylabel('Potential [mV]');
            xlim([0 f1_x_axis(end)])
            hold off
        %-- "nose" analysis
            trace_noseanalysis=mean(nonspike_traces_jitter_raw,2);
            jitter_mean_stimulusdrop=mean(trace_noseanalysis((pretrigger_time+Jitter_time-0.3)*samplingrates{1,i}:...
                                     (pretrigger_time+Jitter_time)*samplingrates{1,i}));
            trace_noseanalysis=trace_noseanalysis-jitter_mean_stimulusdrop;
                nose_integral=trapz(trace_noseanalysis(pretrigger_time*samplingrates{1,i}:(pretrigger_time+0.25)*samplingrates{1,i})); %calculate *10^-5 for value in s*V!

            else
                nose_integral=NaN;
            end
        
        %--calculate firstspike latency:--
        latency_firstspikes=(firstspike_loc-pretrigger_time*samplingrates{1,i})./samplingrates{1,i};
        mean_latency=nanmean(latency_firstspikes);
        median_latency=nanmedian(latency_firstspikes);
        std_latency=nanstd(latency_firstspikes);
        var_latency=nanvar(latency_firstspikes);
        number_of_stimuli=length(latency_firstspikes);
        latency_firstspikes(isnan(latency_firstspikes))=[];
        number_of_spikes=length(latency_firstspikes);
        
        plotsection_Jitter=floor((pretrigger_time-0.005)*samplingrates{1,i}:(pretrigger_time+Jitter_time+0.02)*samplingrates{1,i});
        
        %--plot traces in two colors depending on whether a spike occured
        %or not:--
        if nansum(firstspike_loc)~=0
       
         f_1_2=subplot(4,4,[3,4,7,8]);
         hold on
            for j=1:length(firstspike_loc)
                if isnan(firstspike_loc(j))
                     plot(f1_x_axis(1,plotsection_Jitter),data{1,i}(plotsection_Jitter,j)*1000,'color',[0 0 0]+0.7)
                else
                     plot(f1_x_axis(1,plotsection_Jitter),data{1,i}(plotsection_Jitter,j)*1000,'k')
                end
                plot(firstspike_loc(j)/samplingrates{1,i},max(max(data{1,i}))*1000,'b*')
            end
         xlabel('Time [s]');
         ylabel('Potential [mV]');
         title('Spike traces');
         hold off
            

         %--plot resultswindow:--   
            results_window_text=sprintf(['Jitter #',num2str(Jitter),', applied as protocol #',num2str(i)...
            '\n\nMean latency: ',num2str(mean_latency*1000),' ms'...
            '\nMedian latency: ',num2str(median_latency*1000),' ms'...
            '\nSTD latency: ',num2str(std_latency*1000),' ms'...
            '\nVAR latency: ',num2str(var_latency*1000),' ms'...
            '\nno of spikes: ',num2str(number_of_spikes)...
            ',   no of stimuli: ',num2str(number_of_stimuli)...
            '\nCurrent step: ',num2str(patchmaster_data.(structname{1,1}).stimTree{1,i}{4,3}.seVoltage*1000-holding_current*10^12), ' pA'...
            '\nHolding: ',num2str(holding_current*10^12), ' pA'...
            '\nNose integral: ',num2str(nose_integral),' s*V']); % nose_integral *10^-5 for value in s*V!

        dim1 = [.55 .18 .3 .3];
        annotation('textbox',dim1,'String',results_window_text,'FitBoxToText','on',...
                    'FontSize',9,'FontWeight','bold','horizontalAlignment', 'left');
        
        %--plot firstspike latencies as boxplot:--
        subplot(4,4,15)
        boxplot(latency_firstspikes*1000)
        hold on
        scatter(ones(1,size(latency_firstspikes,2)).*(1+(rand(1,size(latency_firstspikes,2))-0.5)/10),latency_firstspikes*1000,'b','filled')

        xlabel('First spikes');
        ylabel('Latency [ms]');
        hold off
        
        %--plot percentage of 1st spike occurance:--
        no_of_jitterspikes=length(latency_firstspikes);
        perc_per_spike=100/no_of_jitterspikes;
        jittercurve_percentages=1:1*samplingrates{i};
        for j=1:1*samplingrates{i} 
            jittercurve_percentages(j)=sum(latency_firstspikes*samplingrates{i}<j)*(perc_per_spike);
        end
        
        jitter_x=0:1/samplingrates{i}:1;
        jitter_x=jitter_x(1:end-1);
        subplot(4,4,16)
        plot(jitter_x,jittercurve_percentages)
        ylim([-10,110])
        ylabel('1st spike occurance [%]')
        xlabel('stimulus time')
        lastspike_occurance=max(latency_firstspikes);
        %--
        
        else %--if no spkies in recording, print info:--
            results_window_text=sprintf(['no spikes in recording']);

            dim1 = [.55 .18 .3 .3];
            annotation('textbox',dim1,'String',results_window_text,'FitBoxToText','on',...
                        'FontSize',12,'FontWeight','bold','horizontalAlignment', 'center');
        end
        
        %--save extracted data:--
        savedlg=menu('Save figure and results?','Yes','No');
        
        if savedlg==1
        parameternames={};
        parameternames={'Mean_latency_s','Median_latency','STD_latency','spike_occurance_percentage','lastspike_occurance','no_of_applied_stimuli', 'no_of_spikes', 'Current_step','nose_integral_sxV'}';
        

        parametervalues={};
        parametervalues={mean_latency,median_latency,std_latency,jittercurve_percentages,lastspike_occurance,number_of_stimuli,number_of_spikes, current_step_jitter, nose_integral}';                    
        
            for j=1:size(parameternames,1)
                results.(['results_' save_filename]).(['Prot_no_' num2str(i) '_Jitter']).(parameternames{j,1})...
                        ={parametervalues{j,1},7};

            end
            

       
        rawdata.(['rawdata_' save_filename]).(['Prot_no_' num2str(i) '_' Jittername '_rawdata'])=data{1,i};    
        stimulusdata.(['stimulusdata_' save_filename]).(['Prot_no_' num2str(i) '_' Jittername '_stimulusdata']).Jitter_amplitude=Jitter_amplitude; 
        stimulusdata.(['stimulusdata_' save_filename]).(['Prot_no_' num2str(i) '_' Jittername '_stimulusdata']).Jitter_pretrigger_time=pretrigger_time;
        stimulusdata.(['stimulusdata_' save_filename]).(['Prot_no_' num2str(i) '_' Jittername '_stimulusdata']).Jitter_length=Jitter_time;
        stimulusdata.(['stimulusdata_' save_filename]).(['Prot_no_' num2str(i) '_' Jittername '_stimulusdata']).samplingrate=samplingrates{1,i};

        saveas(f1,['figs\' filename '_' Jittername '_prot_no_' num2str(i)])

            set(f1, 'PaperUnits', 'normalized');
            set(f1, 'PaperPosition', [0 0.1 1 .7]); 

        saveas(f1,['jpgs\' filename '_' Jittername '_prot_no_' num2str(i)],'jpg')
        end
        
    elseif strcmp(protocol{1,i},Trainname)    
        %% NOT USED
        
    elseif strcmp(protocol{1,i},const_VCname)
        %% NOT USED
        
    else
        %%
        error=['unknown protocol', protocol{1,i}, 'dataset', i];
        errornames{1,i}=error;        
    end
clc    
else
    continue

end 
end
% save results and display protocol errors:--
if exist('results','var')
    save(['results\' save_filename '_results'], '-struct','results'); 
end
if exist('rawdata','var')
    save(['rawdata\' save_filename '_rawdata'],'-struct','rawdata');
end
if exist('stimulusdata','var')
    save(['rawdata\' save_filename '_stimulusdata'],'-struct','stimulusdata');
end


if exist('errornames','var')
    for i=1:length(errornames)
        if ~isempty(errornames{1,i})
            errornames_print(i,1)=errornames{1,i}(1,2);
        end
    end
errornames_print = errornames_print(~any(cellfun('isempty', errornames_print), 2), :);

errortext=['Analysis done';' ';'Unknown protocols: '; errornames_print];
msgbox(errortext);    
else
    msgbox('done');  
end
