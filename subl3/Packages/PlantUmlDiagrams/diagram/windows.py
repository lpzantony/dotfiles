#!/usr/bin/env python3
# -*- coding: UTF-8 -*-


from .base import BaseViewer
from sublime import platform

try:
    from os import startfile as execute
except ImportError:
    def execute(*args, **kwargs):
        raise Exception('Unable to import os.startfile')


class WindowsDefaultViewer(BaseViewer):
    def __str__(self):
        return "Windows Default Viewer"

    def load(self):
        if platform() != 'windows':
            raise Exception('WindowsDefaultViewer only supported on Windows platforms')

    def view(self, diagram_files):
        for f in diagram_files:
            execute(f.name)
