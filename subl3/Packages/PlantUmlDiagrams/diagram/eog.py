#!/usr/bin/env python3
# -*- coding: UTF-8 -*-


from .base import BaseViewer
import sys
from subprocess import check_call, Popen as run_command


class EyeOfGnomeViewer(BaseViewer):
    def __str__(self):
        return "Eye Of Gnome Viewer"

    def load(self):
        if not check_call("which eog > /dev/null", shell=True) == 0:
            raise Exception("Eye of Gnome not found!")

    def view(self, diagram_files):
        displaycmd = ['eog']
        displaycmd.extend(diagram_file.name for diagram_file in diagram_files)
        run_command(displaycmd).wait()
