# This file handles the conversion of author-review relations to change-review relations.
# It uses the files change-author.csv, author-activity_change.csv, author-activity_review.csv and author-activity_approval_blocking.csv.
# It outputs the files change-activity_change.csv, change-activity_review.csv and change-activity_approval_blocking.csv.

import csv
import os
from datetime import datetime


def format_dict_strings_to_int(dict):
    return {int(key):int(value) for (key, value) in dict.items()}


files = [
    ('change-author', 'dependent/helper'),
    ('author-activity_change', 'predictor/helper'),
    ('author-activity_review', 'predictor/helper'),
    ('author-activity_approval_blocking', 'predictor/helper'),
]

activities = [
    ('change-activity_change', 'author-activity_change'),
    ('change-activity_review', 'author-activity_review'),
    ('change-activity_approval_blocking', 'author-activity_approval_blocking')
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
    for (file, folder) in files:
        path = '../../data/csv/' + project + '/' + folder + '/' + file + '.csv'
        result[file] = format_dict_strings_to_int(get_dict_from_file(path))
    return result


def generate_activities(project):
    log_path = '../../logs/' + os.path.basename(__file__)[:-3]  + '/' + project + '/log_' + datetime.now().strftime('%Y%m%d%H%M%S') + '.log'
    log = open(log_path, 'w+')
    data = get_data(project)
    for (activity, source) in activities:
        path = '../../data/csv/' + project + '/predictor/' + activity + '.csv'
        if os.path.isfile(path):
            os.remove(path)
        out = open(path, 'w+')
        out.write('ch_changeIdNum,' + activity[7:] + '\n')
        for (change, author) in data['change-author'].items():
            try:
                activity_value = data[source][author]
                out.write(str(change) + ',' + str(activity_value)+ '\n')
            except KeyError as e:
                if source == 'author-activity_change':
                    log.write("Any author of a change should have change activity!\n")
                    raise KeyError
                else:
                    log.write(project + '//' + str(activity) + ':: Key ' + str(change) + ' or ' + str(author) + ' not found, continuing without evaluating...\n')


generate_activities('eclipse')
generate_activities('libreoffice')
