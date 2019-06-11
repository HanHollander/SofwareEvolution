# This file handles the conversion of author-first relations to change-tenure relations.
# It uses the files change-author.csv, change_created, author-first_change.csv, author-first_review.csv and author-first_approval_blocking.csv.
# It outputs the files change-tenure_change.csv, change-tenure_review.csv and change-tenure_approval_blocking.csv.

import csv
import os
from datetime import datetime


def format_value_to_datetime(dict):
    return {key:datetime.strptime(s, '%Y-%m-%d %H:%M:%S') for (key, s) in dict.items()}


def format_key_to_int(dict):
    return {int(s):value for (s, value) in dict.items()}


def format_value_to_int(dict):
    return {key:int(s) for (key, s) in dict.items()}


# (file, folder, format1, format2)
files = [
    ('change-author', 'dependent', format_key_to_int, format_value_to_int),
    ('change-created', 'dependent', format_key_to_int, format_value_to_datetime),
    ('author-first_change', 'predictor/helper', format_key_to_int, format_value_to_datetime),
    ('author-first_review', 'predictor/helper', format_key_to_int, format_value_to_datetime),
    ('author-first_approval_blocking', 'predictor/helper', format_key_to_int, format_value_to_datetime),
]


tenures = [
    ('change-tenure_change', 'author-first_change'),
    ('change-tenure_review', 'author-first_review'),
    ('change-tenure_approval_blocking', 'author-first_approval_blocking')
]


def get_dict_from_file(file):
    result = {}
    with open(file) as file:
        reader = csv.reader(file, skipinitialspace=True)
        next(reader, None)
        result = dict(reader)
    return result


def get_data(project):
    result = {}
    for (file, folder, format1, format2) in files:
        path = '../../data/csv/' + project + '/' + folder + '/' + file + '.csv'
        result[file] = format1(format2(get_dict_from_file(path)))
    return result


def generate_tenures(project):
    log_path = '../../logs/' + os.path.basename(__file__)[:-3]  + '/' + project + '/log_' + datetime.now().strftime('%Y%m%d%H%M%S') + '.log'
    log = open(log_path, 'w+')
    data = get_data(project)
    for (tenure, source) in tenures:
        path = '../../data/csv/' + project + '/predictor/' + tenure + '.csv'
        if os.path.isfile(path):
            os.remove(path)
        out = open(path, 'w+')
        out.write('ch_changeIdNum,' + tenure[7:] + '\n')
        for change in data['change-author'].keys():
            try:
                tenure_value = (data['change-created'][change] - data[source][data['change-author'][change]]).days
                out.write(str(change) + ',' + str(tenure_value)+ '\n')
            except KeyError as e:
                if source == 'author-first_change':
                    log.write("Any author of a change should have a first change!\n")
                    raise KeyError
                else:
                    log.write(project + '//' + str(tenure) + ':: Key ' + str(change) + ' or ' + str(data['change-author'][change]) + ' not found, continuing without evaluating...\n')


generate_tenures('eclipse')
generate_tenures('libreoffice')
