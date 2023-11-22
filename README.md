# patchdata-analysis

The "Analysis_script" is used to analyse HEKA Patchmaster files, containing current clamp data recorded using the stimulus protocols defined in "TO BE ADDED".


______________________________

Import of Patchmaster .dat files for analysis requires "sigTOOL" and the "Matlab-Patchmaster" toolbox.

sigTOOL is provided under a GNU GPL licence and can be downloaded here: http://sigtool.sourceforge.net/sigtool.html

The Matlab-Patchmaster toolbox is provided under the MIT licence and can be downloaded here: https://github.com/wormsenseLab/Matlab-PatchMaster/tree/vJGP
______________________________

Preparation:

In order to run this script and save the analysis, the folders containing Patchmaster .dat files need to contain four empty subfolders named "jpgs", "figs", "results" and "rawdata".


To reanalyze a .dat file, run the script and import the .dat file. When asked for protocols to analyze, type the protocol-numbers provided in the separate excel-file as space separated values and confirm your choice. The right stimulus parameters will be extracted automatically and can be confirmed. The script will now run through the stimulus protocols. Occasional user input will be required (follow instructions given on screen). In case further assistance in running the script is needed, please contact the corresponding author.


-----------------------------


For each analyzed .dat file, results of the analysis are stored in the "results" folder and named "filename"_results. Results can be summarized for boxplotting, using the "results_sortingforboxplots" script. After summarizing results like this, boxplots can be plotted using the "boxplot_plotting" script.
