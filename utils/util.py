import shutil
import os
import unidecode


def refresh_folders(*paths):
    for path in paths:
        shutil.rmtree(path)
        os.mkdir(path)


def create_path_if_not_exist(path):
    if not os.path.exists(path):
        os.mkdir(path)


def convert_to_unicode(accented_string):
    return unidecode.unidecode(accented_string).replace(' ', '_')