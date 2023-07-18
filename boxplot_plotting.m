% script to plot boxplots from results sorted by protocol-type. Load sorted results of
% cells from the experimental groups you want to compare. Assign labels according to experimental groups analyzed 

labelone='before pharmacology, n= '; %"group1, rename label according to experiment group, e.g. locomotor, before pharmacology,..."
labeltwo='+ XE991, n= '; %"group2", rename label according to experiment group, e.g. shaker, shaker+XE991,..."
statistics=1; % if "1"--> ranksum, if "2"--> signrank
%% data_prep_plots (remove strings from tables to plot data):
%% stepper plots:

for i=2:size(stepper_results_group1,1)
    for j=2:size(stepper_results_group1,2)
        stepper_results_group1_plot(i,j)=stepper_results_group1{i,j};
    end
end
stepper_results_group1_plot(:,1)=[];
stepper_results_group1_plot(1,:)=[];

for i=2:size(stepper_results_group2,1)
    for j=2:size(stepper_results_group2,2)
        stepper_results_group2_plot(i,j)=stepper_results_group2{i,j};
    end
end
stepper_results_group2_plot(:,1)=[];
stepper_results_group2_plot(1,:)=[];

stepper_size_group1=size(stepper_results_group1_plot,1);
stepper_size_group2=size(stepper_results_group2_plot,1);

if stepper_size_group1>stepper_size_group2
    stepper_results_group2_plot(stepper_size_group2+1:stepper_size_group1,:)=NaN;
elseif stepper_size_group1<stepper_size_group2
    stepper_results_group1_plot(stepper_size_group1+1:stepper_size_group2,:)=NaN;
else
    
end
    
%% longIV plots:

for i=2:size(longIV_results_group1,1)
    for j=2:size(longIV_results_group1,2)
        longIV_results_group1_plot(i,j)=max(longIV_results_group1{i,j});
    end
end
longIV_results_group1_plot(:,1)=[];
longIV_results_group1_plot(1,:)=[];

for i=2:size(longIV_results_group2,1)
    for j=2:size(longIV_results_group2,2)
        longIV_results_group2_plot(i,j)=max(longIV_results_group2{i,j});
    end
end
longIV_results_group2_plot(:,1)=[];
longIV_results_group2_plot(1,:)=[];

longIV_size_group1=size(longIV_results_group1_plot,1);
longIV_size_group2=size(longIV_results_group2_plot,1);

if longIV_size_group1>longIV_size_group2
    longIV_results_group2_plot(longIV_size_group2+1:longIV_size_group1,:)=NaN;
elseif longIV_size_group1<longIV_size_group2
    longIV_results_group1_plot(longIV_size_group1+1:longIV_size_group2,:)=NaN;
else
    
end
%% test_IV plots:

for i=2:size(test_IV_results_group1,1)
    for j=2:size(test_IV_results_group1,2)
        test_IV_results_group1_plot(i,j)=test_IV_results_group1{i,j};
    end
end
test_IV_results_group1_plot(:,1)=[];
test_IV_results_group1_plot(1,:)=[];

for i=2:size(test_IV_results_group2,1)
    for j=2:size(test_IV_results_group2,2)
        test_IV_results_group2_plot(i,j)=test_IV_results_group2{i,j};
    end
end
test_IV_results_group2_plot(:,1)=[];
test_IV_results_group2_plot(1,:)=[];

test_IV_size_group1=size(test_IV_results_group1_plot,1);
test_IV_size_group2=size(test_IV_results_group2_plot,1);

if test_IV_size_group1>test_IV_size_group2
    test_IV_results_group2_plot(test_IV_size_group2+1:test_IV_size_group1,:)=NaN;
elseif test_IV_size_group1<test_IV_size_group2
    test_IV_results_group1_plot(test_IV_size_group1+1:test_IV_size_group2,:)=NaN;
else
    
end
%% ramp IV_plots:

for i=2:size(ramp_IV_results_group1,1)
    for j=2:size(ramp_IV_results_group1,2)
        ramp_IV_results_group1_plot(i,j)=ramp_IV_results_group1{i,j};
    end
end
ramp_IV_results_group1_plot(:,1)=[];
ramp_IV_results_group1_plot(1,:)=[];

for i=2:size(ramp_IV_results_group2,1)
    for j=2:size(ramp_IV_results_group2,2)
        ramp_IV_results_group2_plot(i,j)=ramp_IV_results_group2{i,j};
    end
end
ramp_IV_results_group2_plot(:,1)=[];
ramp_IV_results_group2_plot(1,:)=[];

ramp_IV_size_group1=size(ramp_IV_results_group1_plot,1);
ramp_IV_size_group2=size(ramp_IV_results_group2_plot,1);

if ramp_IV_size_group1>ramp_IV_size_group2
    ramp_IV_results_group2_plot(ramp_IV_size_group2+1:ramp_IV_size_group1,:)=NaN;
elseif ramp_IV_size_group1<ramp_IV_size_group2
    ramp_IV_results_group1_plot(ramp_IV_size_group1+1:ramp_IV_size_group2,:)=NaN;
else
    
end
%% ramptime IV plots:
% not used

%% PP plots
% not used
%% jitter plots

for i=2:size(jitter_results_group1,1)
    for j=2:size(jitter_results_group1,2)
        jitter_results_group1_plot(i,j)=max(jitter_results_group1{i,j});
    end
end
jitter_results_group1_plot(:,1)=[];
jitter_results_group1_plot(1,:)=[];

for i=2:size(jitter_results_group2,1)
    for j=2:size(jitter_results_group2,2)
        jitter_results_group2_plot(i,j)=max(jitter_results_group2{i,j});
    end
end
jitter_results_group2_plot(:,1)=[];
jitter_results_group2_plot(1,:)=[];

jitter_size_group1=size(jitter_results_group1_plot,1);
jitter_size_group2=size(jitter_results_group2_plot,1);

if jitter_size_group1>jitter_size_group2
    jitter_results_group2_plot(jitter_size_group2+1:jitter_size_group1,:)=NaN;
elseif jitter_size_group1<jitter_size_group2
    jitter_results_group1_plot(jitter_size_group1+1:jitter_size_group2,:)=NaN;
else
    
end
%%



%% plot data:

%% stepper:

figure(1)
subplot(1,4,1)
boxplot([stepper_results_group1_plot(:,6).*10^-6 stepper_results_group2_plot(:,6).*10^-6])
hold on

scatter(ones(size(stepper_results_group1_plot,1),1).*(1+(rand(size(stepper_results_group1_plot,1),1)-0.5)/10),stepper_results_group1_plot(:,6).*10^-6,'b','filled')
scatter(ones(size(stepper_results_group1_plot,1),1).*(2+(rand(size(stepper_results_group2_plot,1),1)-0.5)/10),stepper_results_group2_plot(:,6).*10^-6,'r','filled')

hold off
title('Inputs resistance stepper')
ylabel('Resistance [MOhm]')
if statistics==1
    [p,h]=ranksum(stepper_results_group1_plot(:,6),stepper_results_group2_plot(:,6));
elseif statistics==2
    [p,h]=signrank(stepper_results_group1_plot(:,6),stepper_results_group2_plot(:,6));
end
xlabel(['p= ' num2str(p)]);



subplot(1,4,2)
boxplot([stepper_results_group1_plot(:,5).*10^12 stepper_results_group2_plot(:,5).*10^12])
hold on

scatter(ones(size(stepper_results_group1_plot,1),1).*(1+(rand(size(stepper_results_group1_plot,1),1)-0.5)/10),stepper_results_group1_plot(:,5).*10^12,'b','filled')
scatter(ones(size(stepper_results_group1_plot,1),1).*(2+(rand(size(stepper_results_group2_plot,1),1)-0.5)/10),stepper_results_group2_plot(:,5).*10^12,'r','filled')


hold off
title('Capacitance stepper')
ylabel('Capacitance [pF]')
if statistics==1
    [p,h]=ranksum(stepper_results_group1_plot(:,5),stepper_results_group2_plot(:,5));
elseif statistics==2
    [p,h]=signrank(stepper_results_group1_plot(:,5),stepper_results_group2_plot(:,5));
end
    xlabel(['p= ' num2str(p)]);

subplot(1,4,3)
boxplot([stepper_results_group1_plot(:,4).*10^3 stepper_results_group2_plot(:,4).*10^3])
hold on

scatter(ones(size(stepper_results_group1_plot,1),1).*(1+(rand(size(stepper_results_group1_plot,1),1)-0.5)/10),stepper_results_group1_plot(:,4).*10^3,'b','filled')
scatter(ones(size(stepper_results_group1_plot,1),1).*(2+(rand(size(stepper_results_group2_plot,1),1)-0.5)/10),stepper_results_group2_plot(:,4).*10^3,'r','filled')

hold off
title('Tau stepper')
ylabel('Tau [ms]')
if statistics==1
    [p,h]=ranksum(stepper_results_group1_plot(:,4),stepper_results_group2_plot(:,4));
elseif statistics==2
    [p,h]=signrank(stepper_results_group1_plot(:,4),stepper_results_group2_plot(:,4));
end

xlabel(['p= ' num2str(p)]);

subplot(1,4,4)
boxplot([stepper_results_group1_plot(:,1).*10^3 stepper_results_group2_plot(:,1).*10^3])
hold on

scatter(ones(size(stepper_results_group1_plot,1),1).*(1+(rand(size(stepper_results_group1_plot,1),1)-0.5)/10),stepper_results_group1_plot(:,1).*10^3,'b','filled')
scatter(ones(size(stepper_results_group1_plot,1),1).*(2+(rand(size(stepper_results_group2_plot,1),1)-0.5)/10),stepper_results_group2_plot(:,1).*10^3,'r','filled')

hold off
title('Resting stepper')
ylabel('Potential [mV]')
if statistics==1
    [p,h]=ranksum(stepper_results_group1_plot(:,1),stepper_results_group2_plot(:,1));
elseif statistics==2
    [p,h]=signrank(stepper_results_group1_plot(:,1),stepper_results_group2_plot(:,1));
end
xlabel(['p= ' num2str(p)]);

legend([labelone num2str(stepper_size_group1)],[labeltwo num2str(stepper_size_group2)])

%% longIV:

figure(2)
subplot(1,3,1)
boxplot([longIV_results_group1_plot(:,1).*10^-6 longIV_results_group2_plot(:,1).*10^-6])
hold on

scatter(ones(size(longIV_results_group1_plot,1),1).*(1+(rand(size(longIV_results_group1_plot,1),1)-0.5)/10),longIV_results_group1_plot(:,1).*10^-6,'b','filled')
scatter(ones(size(longIV_results_group1_plot,1),1).*(2+(rand(size(longIV_results_group2_plot,1),1)-0.5)/10),longIV_results_group2_plot(:,1).*10^-6,'r','filled')

hold off
title('Input resistance longIV')
ylabel('resistance [MOhm]')
if statistics==1
    [p,h]=ranksum(longIV_results_group1_plot(:,1),longIV_results_group2_plot(:,1));
elseif statistics==2
    [p,h]=signrank(longIV_results_group1_plot(:,1),longIV_results_group2_plot(:,1));
end
xlabel(['p= ' num2str(p)]);
legend([labelone num2str(longIV_size_group1)],[labeltwo num2str(longIV_size_group2)])

subplot(1,3,2)
boxplot([longIV_results_group1_plot(:,6) longIV_results_group2_plot(:,6)])
hold on

scatter(ones(size(longIV_results_group1_plot,1),1).*(1+(rand(size(longIV_results_group1_plot,1),1)-0.5)/10),longIV_results_group1_plot(:,6),'b','filled')
scatter(ones(size(longIV_results_group1_plot,1),1).*(2+(rand(size(longIV_results_group2_plot,1),1)-0.5)/10),longIV_results_group2_plot(:,6),'r','filled')

hold off
title('Maximum IF Frequency longIV')
ylabel('max freq. [Hz]')
if statistics==1
    [p,h]=ranksum(longIV_results_group1_plot(:,6),longIV_results_group2_plot(:,6));
elseif statistics==2
    [p,h]=signrank(longIV_results_group1_plot(:,6),longIV_results_group2_plot(:,6));
end
xlabel(['p= ' num2str(p)]);

subplot(1,3,3)
boxplot([longIV_results_group1_plot(:,9) longIV_results_group2_plot(:,9)])
hold on

scatter(ones(size(longIV_results_group1_plot,1),1).*(1+(rand(size(longIV_results_group1_plot,1),1)-0.5)/10),longIV_results_group1_plot(:,9),'b','filled')
scatter(ones(size(longIV_results_group1_plot,1),1).*(2+(rand(size(longIV_results_group2_plot,1),1)-0.5)/10),longIV_results_group2_plot(:,9),'r','filled')

hold off
title('dAP height normalized')
ylabel('dAP height [%]')
if statistics==1
    [p,h]=ranksum(longIV_results_group1_plot(:,9),longIV_results_group2_plot(:,9));
elseif statistics==2
    [p,h]=signrank(longIV_results_group1_plot(:,9),longIV_results_group2_plot(:,9));
end
xlabel(['p= ' num2str(p)]);

%% test_IV

figure(3)
subplot(1,2,1)
boxplot([test_IV_results_group1_plot(:,1).*10^12 test_IV_results_group2_plot(:,1).*10^12])
hold on

scatter(ones(size(test_IV_results_group1_plot,1),1).*(1+(rand(size(test_IV_results_group1_plot,1),1)-0.5)/10),test_IV_results_group1_plot(:,1).*10^12,'b','filled')
scatter(ones(size(test_IV_results_group1_plot,1),1).*(2+(rand(size(test_IV_results_group2_plot,1),1)-0.5)/10),test_IV_results_group2_plot(:,1).*10^12,'r','filled')

hold off
title('Rheobase test IV')
ylabel('Input Current [pA]')
if statistics==1
    [p,h]=ranksum(test_IV_results_group1_plot(:,1),test_IV_results_group2_plot(:,1));
elseif statistics==2
    [p,h]=signrank(test_IV_results_group1_plot(:,1),test_IV_results_group2_plot(:,1));
end
xlabel(['p= ' num2str(p)]);

subplot(1,2,2)
boxplot([test_IV_results_group1_plot(:,4).*10^3 test_IV_results_group2_plot(:,4).*10^3])
hold on

scatter(ones(size(test_IV_results_group1_plot,1),1).*(1+(rand(size(test_IV_results_group1_plot,1),1)-0.5)/10),test_IV_results_group1_plot(:,4).*10^3,'b','filled')
scatter(ones(size(test_IV_results_group1_plot,1),1).*(2+(rand(size(test_IV_results_group2_plot,1),1)-0.5)/10),test_IV_results_group2_plot(:,4).*10^3,'r','filled')

hold off
title('Rheobase Ap latency test IV')
ylabel('Latency [ms]')
if statistics==1
    [p,h]=ranksum(test_IV_results_group1_plot(:,4),test_IV_results_group2_plot(:,4));
elseif statistics==2
    [p,h]=signrank(test_IV_results_group1_plot(:,4),test_IV_results_group2_plot(:,4));
end
xlabel(['p= ' num2str(p)]);

legend([labelone num2str(test_IV_size_group1)],[labeltwo num2str(test_IV_size_group2)])

%% ramp IV

figure(6)
subplot(2,5,1)
boxplot([ramp_IV_results_group1_plot(:,1).*10^3 ramp_IV_results_group2_plot(:,1).*10^3])
hold on

scatter(ones(size(ramp_IV_results_group1_plot,1),1).*(1+(rand(size(ramp_IV_results_group1_plot,1),1)-0.5)/10),ramp_IV_results_group1_plot(:,1).*10^3,'b','filled')
scatter(ones(size(ramp_IV_results_group1_plot,1),1).*(2+(rand(size(ramp_IV_results_group2_plot,1),1)-0.5)/10),ramp_IV_results_group2_plot(:,1).*10^3,'r','filled')

hold off
title('AP amplitude calc ramp IV')
ylabel('AP amplitude [mV]')
if statistics==1
    [p,h]=ranksum(ramp_IV_results_group1_plot(:,1),ramp_IV_results_group2_plot(:,1));
elseif statistics==2
    [p,h]=signrank(ramp_IV_results_group1_plot(:,1),ramp_IV_results_group2_plot(:,1));
end
xlabel(['p= ' num2str(p)]);
legend([labelone num2str(ramp_IV_size_group1)],[labeltwo num2str(ramp_IV_size_group2)])

subplot(2,5,2)
boxplot([ramp_IV_results_group1_plot(:,3).*10^3 ramp_IV_results_group2_plot(:,3).*10^3])
hold on

scatter(ones(size(ramp_IV_results_group1_plot,1),1).*(1+(rand(size(ramp_IV_results_group1_plot,1),1)-0.5)/10),ramp_IV_results_group1_plot(:,3).*10^3,'b','filled')
scatter(ones(size(ramp_IV_results_group1_plot,1),1).*(2+(rand(size(ramp_IV_results_group2_plot,1),1)-0.5)/10),ramp_IV_results_group2_plot(:,3).*10^3,'r','filled')

hold off
title('AP FWHM calc ramp IV')
ylabel('AP FWHM [ms]')
if statistics==1
    [p,h]=ranksum(ramp_IV_results_group1_plot(:,3),ramp_IV_results_group2_plot(:,3));
elseif statistics==2
    [p,h]=signrank(ramp_IV_results_group1_plot(:,3),ramp_IV_results_group2_plot(:,3));
end
xlabel(['p= ' num2str(p)]);

subplot(2,5,3)
boxplot([ramp_IV_results_group1_plot(:,2).*10^3 ramp_IV_results_group2_plot(:,2).*10^3])
hold on

scatter(ones(size(ramp_IV_results_group1_plot,1),1).*(1+(rand(size(ramp_IV_results_group1_plot,1),1)-0.5)/10),ramp_IV_results_group1_plot(:,2).*10^3,'b','filled')
scatter(ones(size(ramp_IV_results_group1_plot,1),1).*(2+(rand(size(ramp_IV_results_group2_plot,1),1)-0.5)/10),ramp_IV_results_group2_plot(:,2).*10^3,'r','filled')

hold off
title('AHP amplitude calc ramp IV')
ylabel('AHP amplitude [mV]')
if statistics==1
    [p,h]=ranksum(ramp_IV_results_group1_plot(:,2),ramp_IV_results_group2_plot(:,2));
elseif statistics==2
    [p,h]=signrank(ramp_IV_results_group1_plot(:,2),ramp_IV_results_group2_plot(:,2));
end
xlabel(['p= ' num2str(p)]);

subplot(2,5,4)
boxplot([ramp_IV_results_group1_plot(:,4).*10^3 ramp_IV_results_group2_plot(:,4).*10^3])
hold on

scatter(ones(size(ramp_IV_results_group1_plot,1),1).*(1+(rand(size(ramp_IV_results_group1_plot,1),1)-0.5)/10),ramp_IV_results_group1_plot(:,4).*10^3,'b','filled')
scatter(ones(size(ramp_IV_results_group1_plot,1),1).*(2+(rand(size(ramp_IV_results_group2_plot,1),1)-0.5)/10),ramp_IV_results_group2_plot(:,4).*10^3,'r','filled')

hold off
title('AHP FWHM calc ramp IV')
ylabel('AHP FWHM [ms]')
if statistics==1
    [p,h]=ranksum(ramp_IV_results_group1_plot(:,4),ramp_IV_results_group2_plot(:,4));
elseif statistics==2
    [p,h]=signrank(ramp_IV_results_group1_plot(:,4),ramp_IV_results_group2_plot(:,4));
end
xlabel(['p= ' num2str(p)]);

subplot(2,5,5)
boxplot([ramp_IV_results_group1_plot(:,5).*10^3 ramp_IV_results_group2_plot(:,5).*10^3])
hold on

scatter(ones(size(ramp_IV_results_group1_plot,1),1).*(1+(rand(size(ramp_IV_results_group1_plot,1),1)-0.5)/10),ramp_IV_results_group1_plot(:,5).*10^3,'b','filled')
scatter(ones(size(ramp_IV_results_group1_plot,1),1).*(2+(rand(size(ramp_IV_results_group2_plot,1),1)-0.5)/10),ramp_IV_results_group2_plot(:,5).*10^3,'r','filled')

hold off
title('Threshold ramp IV')
ylabel('Threshold [mV]')
if statistics==1
    [p,h]=ranksum(ramp_IV_results_group1_plot(:,5),ramp_IV_results_group2_plot(:,5));
elseif statistics==2
    [p,h]=signrank(ramp_IV_results_group1_plot(:,5),ramp_IV_results_group2_plot(:,5));
end
xlabel(['p= ' num2str(p)]);


subplot(2,5,6)
boxplot([ramp_IV_results_group1_plot(:,6).*10^3 ramp_IV_results_group2_plot(:,6).*10^3])
hold on

scatter(ones(size(ramp_IV_results_group1_plot,1),1).*(1+(rand(size(ramp_IV_results_group1_plot,1),1)-0.5)/10),ramp_IV_results_group1_plot(:,6).*10^3,'b','filled')
scatter(ones(size(ramp_IV_results_group1_plot,1),1).*(2+(rand(size(ramp_IV_results_group2_plot,1),1)-0.5)/10),ramp_IV_results_group2_plot(:,6).*10^3,'r','filled')

hold off
title('AP amplitude orig. ramp IV')
ylabel('AP amplitude [mV]')
if statistics==1
    [p,h]=ranksum(ramp_IV_results_group1_plot(:,6),ramp_IV_results_group2_plot(:,6));
elseif statistics==2
    [p,h]=signrank(ramp_IV_results_group1_plot(:,6),ramp_IV_results_group2_plot(:,6));
end
xlabel(['p= ' num2str(p)]);

subplot(2,5,7)
boxplot([ramp_IV_results_group1_plot(:,8).*10^3 ramp_IV_results_group2_plot(:,8).*10^3])
hold on

scatter(ones(size(ramp_IV_results_group1_plot,1),1).*(1+(rand(size(ramp_IV_results_group1_plot,1),1)-0.5)/10),ramp_IV_results_group1_plot(:,8).*10^3,'b','filled')
scatter(ones(size(ramp_IV_results_group1_plot,1),1).*(2+(rand(size(ramp_IV_results_group2_plot,1),1)-0.5)/10),ramp_IV_results_group2_plot(:,8).*10^3,'r','filled')

hold off
title('AP FWHM orig. ramp IV')
ylabel('AP FWHM [ms]')
if statistics==1
    [p,h]=ranksum(ramp_IV_results_group1_plot(:,8),ramp_IV_results_group2_plot(:,8));
elseif statistics==2
    [p,h]=signrank(ramp_IV_results_group1_plot(:,8),ramp_IV_results_group2_plot(:,8));
end
xlabel(['p= ' num2str(p)]);

subplot(2,5,8)
boxplot([ramp_IV_results_group1_plot(:,7).*10^3 ramp_IV_results_group2_plot(:,7).*10^3])
hold on

scatter(ones(size(ramp_IV_results_group1_plot,1),1).*(1+(rand(size(ramp_IV_results_group1_plot,1),1)-0.5)/10),ramp_IV_results_group1_plot(:,7).*10^3,'b','filled')
scatter(ones(size(ramp_IV_results_group1_plot,1),1).*(2+(rand(size(ramp_IV_results_group2_plot,1),1)-0.5)/10),ramp_IV_results_group2_plot(:,7).*10^3,'r','filled')

hold off
title('AHP amplitude orig. ramp IV')
ylabel('AHP amplitude [mV]')
if statistics==1
    [p,h]=ranksum(ramp_IV_results_group1_plot(:,7),ramp_IV_results_group2_plot(:,7));
elseif statistics==2
    [p,h]=signrank(ramp_IV_results_group1_plot(:,7),ramp_IV_results_group2_plot(:,7));
end
xlabel(['p= ' num2str(p)]);

subplot(2,5,9)
boxplot([ramp_IV_results_group1_plot(:,9).*10^3 ramp_IV_results_group2_plot(:,9).*10^3])
hold on

scatter(ones(size(ramp_IV_results_group1_plot,1),1).*(1+(rand(size(ramp_IV_results_group1_plot,1),1)-0.5)/10),ramp_IV_results_group1_plot(:,9).*10^3,'b','filled')
scatter(ones(size(ramp_IV_results_group1_plot,1),1).*(2+(rand(size(ramp_IV_results_group2_plot,1),1)-0.5)/10),ramp_IV_results_group2_plot(:,9).*10^3,'r','filled')

hold off
title('AHP FWHM orig. ramp IV')
ylabel('AHP FWHM [ms]')
if statistics==1
    [p,h]=ranksum(ramp_IV_results_group1_plot(:,9),ramp_IV_results_group2_plot(:,9));
elseif statistics==2
    [p,h]=signrank(ramp_IV_results_group1_plot(:,9),ramp_IV_results_group2_plot(:,9));
end
xlabel(['p= ' num2str(p)]);

subplot(2,5,10)
boxplot([ramp_IV_results_group1_plot(:,10).*10^12 ramp_IV_results_group2_plot(:,10).*10^12])
hold on

scatter(ones(size(ramp_IV_results_group1_plot,1),1).*(1+(rand(size(ramp_IV_results_group1_plot,1),1)-0.5)/10),ramp_IV_results_group1_plot(:,10).*10^12,'b','filled')
scatter(ones(size(ramp_IV_results_group1_plot,1),1).*(2+(rand(size(ramp_IV_results_group2_plot,1),1)-0.5)/10),ramp_IV_results_group2_plot(:,10).*10^12,'r','filled')

hold off
title('Trigg. current ramp IV')
ylabel('Trigg. current [pA]')
if statistics==1
    [p,h]=ranksum(ramp_IV_results_group1_plot(:,10),ramp_IV_results_group2_plot(:,10));
elseif statistics==2
    [p,h]=signrank(ramp_IV_results_group1_plot(:,10),ramp_IV_results_group2_plot(:,10));
end
xlabel(['p= ' num2str(p)]);


%% ramptime IV
% not used

%% PP
% not used


%% Jitter

figure(5)
subplot(1,3,1)
boxplot([jitter_results_group1_plot(:,1).*10^3 jitter_results_group2_plot(:,1).*10^3])
hold on

scatter(ones(size(jitter_results_group1_plot,1),1).*(1+(rand(size(jitter_results_group1_plot,1),1)-0.5)/10),jitter_results_group1_plot(:,1).*10^3,'b','filled')
scatter(ones(size(jitter_results_group1_plot,1),1).*(2+(rand(size(jitter_results_group2_plot,1),1)-0.5)/10),jitter_results_group2_plot(:,1).*10^3,'r','filled')

hold off
title('AP latency jitter')
ylabel('AP latency [ms]')
if statistics==1
    [p,h]=ranksum(jitter_results_group1_plot(:,1),jitter_results_group2_plot(:,1));
elseif statistics==2
    [p,h]=signrank(jitter_results_group1_plot(:,1),jitter_results_group2_plot(:,1));
end
xlabel(['p= ' num2str(p)]);

legend([labelone num2str(jitter_size_group1)],[labeltwo num2str(jitter_size_group2)])

subplot(1,3,2)
boxplot([jitter_results_group1_plot(:,3).*10^3 jitter_results_group2_plot(:,3).*10^3])
hold on
scatter(ones(size(jitter_results_group1_plot,1),1).*(1+(rand(size(jitter_results_group1_plot,1),1)-0.5)/10),jitter_results_group1_plot(:,3).*10^3,'b','filled')
scatter(ones(size(jitter_results_group1_plot,1),1).*(2+(rand(size(jitter_results_group2_plot,1),1)-0.5)/10),jitter_results_group2_plot(:,3).*10^3,'r','filled')

title('AP latency std (=jitter)')
ylabel('AP latency std [ms]')

if statistics==1
    [p,h]=ranksum(jitter_results_group1_plot(:,9),jitter_results_group2_plot(:,9));
elseif statistics==2
    [p,h]=signrank(jitter_results_group1_plot(:,9),jitter_results_group2_plot(:,9));
end
xlabel(['p= ' num2str(p)]);

subplot(1,3,3)
boxplot([jitter_results_group1_plot(:,9) jitter_results_group2_plot(:,9)])
hold on

scatter(ones(size(jitter_results_group1_plot,1),1).*(1+(rand(size(jitter_results_group1_plot,1),1)-0.5)/10),jitter_results_group1_plot(:,9),'b','filled')
scatter(ones(size(jitter_results_group1_plot,1),1).*(2+(rand(size(jitter_results_group2_plot,1),1)-0.5)/10),jitter_results_group2_plot(:,9),'r','filled')

hold off
title('Nose integral')
ylabel('Nose integral [s*V]')
if statistics==1
    [p,h]=ranksum(jitter_results_group1_plot(:,9),jitter_results_group2_plot(:,9));
elseif statistics==2
    [p,h]=signrank(jitter_results_group1_plot(:,9),jitter_results_group2_plot(:,9));
end
xlabel(['p= ' num2str(p)]);
%% set figure renderer to get all info in figure

fig1=figure(1);
fig1.Renderer='Painters';
fig2=figure(2);
fig2.Renderer='Painters';
fig3=figure(3);
fig3.Renderer='Painters';
fig5=figure(5);
fig5.Renderer='Painters';
fig6=figure(6);
fig6.Renderer='Painters';