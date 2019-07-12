# Simple script to generate configuration scripts for 18 treatements for each selection scheme

# Constants
NUM_SAMPLES = 100000
OUTPUT_DIR = './configs/'

# Variable lists
pop_size_L = [10, 20, 100]
num_tests_L = [10, 20]
pass_prob_L = [1, 0.1, 0.01]
subsampling_levels_L = [0.5, 0.2]
tourney_sizes_L = [2,4,7]

def get_config_name(pop_size, num_tests, pass_prob):
    return str(num_tests) + '__' + str(pop_size) + '__' + str(pass_prob).replace('.','_')

def write_generic_file(filename, \
        scheme_id, \
        input_filename, \
        output_filename, \
        lex_do_subsampling, \
        lex_sub_group_size, \
        lex_sub_test_count, \
        lex_sub_num_samples, \
        tourney_size, \
        tourney_num_samples):    
    with open(OUTPUT_DIR + filename, 'w') as fp:
        fp.write(\
        "### GENERAL ###\n" + \
        "# General settings that apply to all selection schemes\n" + \
        "\n" + \
        "set SELECTION_SCHEME " + str(scheme_id) + " " + \
        "# The type of selection to be analyzed. 0 for lexicase, 1 for tournament, " + \
        "2 for elite, 3 for roulette.\n" + \
        "set INPUT_FILENAME " + input_filename + " " + \
        "# The path of the file containing the data to be used.\n" + \
        "set OUTPUT_FILENAME " + output_filename + " " + \
        "# The path to a file that will be created to save the generated selection " + \
        "probabilities. (Leave blank for std::out)\n" + \
        "set NO_COL_HEADINGS 0 " + \
        "# Set to true if column headers have already been removed.\n" + \
        "set VERBOSE 0 " + \
        "# Prints more information during computation, useful for debugging.\n" + \
        "\n" + \
        "### AGGREGATE ###\n" + \
        "# Settings that apply to all selection schemes that aggregate fitness across " + \
        "test cases (i.e., not lexicase selection).\n" + \
        "\n" + \
        "set AGGREGATE_FIT_IDX 1 # Index of the column that contains aggregate fitness " + \
        "values to be used in selection.\n" + \
        "\n" + \
        "### LEXICASE ###\n" + \
        "# Settings that apply only to lexicase selection (SELECTION_SCHEME = 0)." + \
        "\n" + \
        "set LEXICASE_START_IDX 2 # Index of the column (starting at zero) " + \
        "that represents a test case to be used in lexicase. " + \
        "Note: There should be no columns following the test case columns.\n" + \
        "set LEXICASE_DO_SUBSAMPLING " + str(int(lex_do_subsampling)) + " " + \
        "# If 1, LEXICASE_POP_SAMPLING, LEXICASE_TEST_SAMPLING and LEXICASE_SUBSAMPLING_SAMPLES " + \
        "will be used. Note: this is an estimated analysis.\n" + \
        "set LEXICASE_SUBSAMPLING_GROUP_SIZE " + str(lex_sub_group_size) + " " + \
        "# How many individuals will be sampled before doing lexicase selection. " + \
        "For cohort selection, this is cohort size. " + \
        "(a value of zero gives the whole population (such as in downsampled lexicase).\n" + \
        "set LEXICASE_SUBSAMPLING_TEST_COUNT " + str(lex_sub_test_count) + " " + \
        "# Number of tests to sample before running  lexicase selection (0 for all).\n" + \
        "set LEXICASE_SUBSAMPLING_NUM_SAMPLES " +  str(lex_sub_num_samples) + " " + \
        "# Number of times to sample the configuration. " + \
        "The larger the number, the closer the estimate should be to the true value.\n" + \
        "\n" + \
        "### TOURNAMENT ###\n" + \
        "# Settings that apply only to tournament selection (SELECTION_SCHEME = 1).\n" + \
        "\n" + \
        "set TOURNAMENT_SIZE " + str(tourney_size) + " " + \
        "# Number of organisms in each tournament. (0 for whole population)\n" + \
        "set TOURNAMENT_SAMPLES "+ str(tourney_num_samples) +  " " + \
        "# Number of times to sample the configuration. " + \
        "The larger the value, the closer the estimate should be to the true value.\n" \
        )

def write_lexicase_file(pop_size, num_tests, pass_prob):
    write_generic_file('lexicase__' + get_config_name(pop_size, num_tests, pass_prob) + '.cfg', \
        0,     # scheme_id
        '',    # input_filename
        '',    # output_filename
        False, # lex_do_subsampling
        0,     #lex_sub_group_size
        0,     #lex_sub_test_count
        NUM_SAMPLES, #lex_sub_num_samples
        0,           #tourney_size
        NUM_SAMPLES) #tourney_num_samples

def write_cohort_files(pop_size, num_tests, pass_prob):
    for sub_level in subsampling_levels_L:
        write_generic_file( \
            'cohort_' + str(sub_level).replace('.', '_') +  '__'+ \
            get_config_name(pop_size, num_tests, pass_prob) + '.cfg', \
            0,     #scheme_id
            '',    #input_filename
            '',    #output_filename
            True,  #lex_do_subsampling
            int(pop_size * sub_level),  #lex_sub_group_size
            int(num_tests * sub_level), #lex_sub_test_count
            NUM_SAMPLES,  #lex_sub_num_samples
            0,            #tourney_size
            NUM_SAMPLES)  #tourney_num_samples

def write_downsampled_files(pop_size, num_tests, pass_prob):
    for sub_level in subsampling_levels_L:
        write_generic_file( \
            'downsampled_' + str(sub_level).replace('.', '_') +  '__'+ \
            get_config_name(pop_size, num_tests, pass_prob) + '.cfg', \
            0,     #scheme_id
            '',    #input_filename
            '',    #output_filename
            True,  #lex_do_subsampling
            0,  #lex_sub_group_size
            int(num_tests * sub_level), #lex_sub_test_count
            NUM_SAMPLES,  #lex_sub_num_samples
            0,            #tourney_size
            NUM_SAMPLES)  #tourney_num_samples

def write_tournament_files(pop_size, num_tests, pass_prob):
    for tourney_size in tourney_sizes_L:
        write_generic_file( \
            'tournament_' + str(tourney_size) +  '__'+ \
            get_config_name(pop_size, num_tests, pass_prob) + '.cfg', \
            1,     #scheme_id
            '',    #input_filename
            '',    #output_filename
            False,  #lex_do_subsampling
            0,  #lex_sub_group_size
            0, #lex_sub_test_count
            NUM_SAMPLES,  #lex_sub_num_samples
            tourney_size, #tourney_size
            NUM_SAMPLES)  #tourney_num_samples

def write_roulette_file(pop_size, num_tests, pass_prob):
    write_generic_file('roulette__' + get_config_name(pop_size, num_tests, pass_prob) + '.cfg', \
        3,     # scheme_id
        '',    # input_filename
        '',    # output_filename
        False, # lex_do_subsampling
        0,     #lex_sub_group_size
        0,     #lex_sub_test_count
        NUM_SAMPLES, #lex_sub_num_samples
        0,           #tourney_size
        NUM_SAMPLES) #tourney_num_samples

if __name__ == '__main__':
    for pop_size in pop_size_L:
        for num_tests in num_tests_L:
            for pass_prob in pass_prob_L:
                write_lexicase_file(pop_size, num_tests, pass_prob)
                write_cohort_files(pop_size, num_tests, pass_prob)
                write_downsampled_files(pop_size, num_tests, pass_prob)
                write_tournament_files(pop_size, num_tests, pass_prob)
                write_roulette_file(pop_size, num_tests, pass_prob)
