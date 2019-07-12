# Simple script to generate a shell script that will run all specified replicates 

import os
import stat

# (Pseudo)-Constants
CONFIG_DIR = './configs/'
NUM_REPLICATES = 100
EXECUTABLE_NAME = './SelectionAnalyze'
INPUT_DIR = './populations/'
OUTPUT_DIR = './output/'
SCRIPT_PREAMBLE = '../run_experiments'
SCRIPT_POSTAMBLE = '.sh'

# Variable lists
pop_size_L = [10, 20, 100]
num_tests_L = [10, 20]
pass_prob_L = [1, 0.1, 0.01]
subsampling_levels_L = [0.5, 0.2]
tourney_sizes_L = [2,4,7]

# Toggle for each selection scheme
# To only scheme with a value of true will be executed
scheme_map = {}
scheme_map['lexicase'] = True
scheme_map['cohort'] = True
scheme_map['downsampled'] = True
scheme_map['tournament'] = True
scheme_map['roulette'] = True


# Verify directory endings
if CONFIG_DIR[-1] != '/':
    CONFIG_DIR += '/'
if INPUT_DIR[-1] != '/':
    INPUT_DIR += '/'
if OUTPUT_DIR[-1] != '/':
    OUTPUT_DIR += '/'


def get_config_name(pop_size, num_tests, pass_prob):
    return str(num_tests) + '__' + str(pop_size) + '__' + str(pass_prob).replace('.','_')

def get_input_name(pop_size, num_tests, pass_prob, rep_id):
    return 'Population_' + str(num_tests) + '_' + str(pop_size) + \
        '_' + str(pass_prob) + '_' + str(rep_id)

def get_generic_line(config_path, input_path, output_path):
    s = '' 
    s += EXECUTABLE_NAME + ' ' + \
        '-CONFIG ' + config_path + ' ' + \
        '-INPUT_FILENAME ' + input_path + ' ' + \
        '-OUTPUT_FILENAME ' + output_path
    return s 

def get_lexicase_lines(pop_size, num_tests, pass_prob, rep_id):
    s = ''
    s += get_generic_line(
        CONFIG_DIR + 'lexicase__' + get_config_name(pop_size, num_tests, pass_prob) + '.cfg', \
        INPUT_DIR + get_input_name(pop_size, num_tests, pass_prob, rep_id) + '.csv', \
        OUTPUT_DIR + 'lexicase__' + get_config_name(pop_size, num_tests, pass_prob) + \
        '__' + str(rep_id) + '.csv' \
    ) + '\n'
    return s 

def get_cohort_lines(pop_size, num_tests, pass_prob, rep_id):
    s = ''
    for sub_level in subsampling_levels_L:
        cohort_str = 'cohort_' + str(sub_level).replace('.','_') + '__'
        s += get_generic_line(
            CONFIG_DIR + cohort_str + get_config_name(pop_size, num_tests, pass_prob) + '.cfg', \
            INPUT_DIR + get_input_name(pop_size, num_tests, pass_prob, rep_id) + '.csv', \
            OUTPUT_DIR + cohort_str + get_config_name(pop_size, num_tests, pass_prob) + \
            '__' + str(rep_id) + '.csv' \
        ) + '\n'
    return s 

def get_downsampled_lines(pop_size, num_tests, pass_prob, rep_id):
    s = ''
    for sub_level in subsampling_levels_L:
        downsampled_str = 'downsampled_' + str(sub_level).replace('.','_') + '__'
        s += get_generic_line(
            CONFIG_DIR + downsampled_str + \
                get_config_name(pop_size, num_tests, pass_prob) + '.cfg', \
            INPUT_DIR + get_input_name(pop_size, num_tests, pass_prob, rep_id) + '.csv', \
            OUTPUT_DIR + downsampled_str + get_config_name(pop_size, num_tests, pass_prob) + \
            '__' + str(rep_id) + '.csv' \
        ) + '\n'
    return s 

def get_tournament_lines(pop_size, num_tests, pass_prob, rep_id):
    s = ''
    for tourney_size in tourney_sizes_L:
        tourney_str = 'tournament_' + str(tourney_size).replace('.','_') + '__'
        s += get_generic_line(
            CONFIG_DIR + tourney_str + \
                get_config_name(pop_size, num_tests, pass_prob) + '.cfg', \
            INPUT_DIR + get_input_name(pop_size, num_tests, pass_prob, rep_id) + '.csv', \
            OUTPUT_DIR + tourney_str + get_config_name(pop_size, num_tests, pass_prob) + \
            '__' + str(rep_id) + '.csv' \
        ) + '\n'
    return s 

def get_roulette_lines(pop_size, num_tests, pass_prob, rep_id):
    s = ''
    s += get_generic_line(
        CONFIG_DIR + 'roulette__' + get_config_name(pop_size, num_tests, pass_prob) + '.cfg', \
        INPUT_DIR + get_input_name(pop_size, num_tests, pass_prob, rep_id) + '.csv', \
        OUTPUT_DIR + 'roulette__' + get_config_name(pop_size, num_tests, pass_prob) + \
        '__' + str(rep_id) + '.csv' \
    ) + '\n'
    return s


if __name__ == '__main__':
    for rep_id in range(1, NUM_REPLICATES + 1):
        filename = SCRIPT_PREAMBLE + '_' + str(rep_id)  + SCRIPT_POSTAMBLE
        with open(filename, 'w') as fp:    
            # Shebang!
            fp.write('#!/bin/bash\n\n')
            for pop_size in pop_size_L:
                fp.write('echo "Starting pop size: ' + str(pop_size) + '"\n')
                for num_tests in num_tests_L:
                    fp.write('echo "\tStarting test count: ' + str(num_tests) + '"\n')
                    for pass_prob in pass_prob_L:
                        fp.write('echo "\t\tStarting pass prob: ' + str(pass_prob) + '"\n')
                        if scheme_map['lexicase']:
                            fp.write(get_lexicase_lines(pop_size, num_tests, pass_prob, rep_id))
                        if scheme_map['cohort']:
                            fp.write(get_cohort_lines(pop_size, num_tests, pass_prob, rep_id))
                        if scheme_map['downsampled']:
                            fp.write(get_downsampled_lines(pop_size, num_tests, pass_prob, rep_id))
                        if scheme_map['tournament']:
                            fp.write(get_tournament_lines(pop_size, num_tests, pass_prob, rep_id))
                        if scheme_map['roulette']:
                            fp.write(get_roulette_lines(pop_size, num_tests, pass_prob, rep_id))
        # Make file executable by all
        cur_mode = os.stat(filename).st_mode
        os.chmod(filename, cur_mode | stat.S_IXUSR | stat.S_IXGRP | stat.S_IXOTH)
