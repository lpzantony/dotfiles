#!/usr/bin/env python3
# -*- coding: UTF-8 -*-


from debug_tools import getLogger
log = getLogger(__name__)

import sys

class BaseDiagram(object):
    def __init__(self, processor, sourceFile, text):
        self.uml_processor = processor
        self.text = text
        self.sourceFile = sourceFile

    def __str__(self):
        return "Base Diagram %s(%s)" % ( self.sourceFile, self.uml_processor )

    def generate(self):
        raise NotImplementedError('abstract base class is abstract')


class BaseProcessor(object):
    DIAGRAM_CLASS = None
    CHARSET = None
    CHECK_ON_STARTUP = True
    NEW_FILE = False

    def __str__(self):
        return "Base Processor"

    def load(self):
        raise NotImplementedError('abstract base class is abstract')

    def extract_blocks(self, view):
        raise NotImplementedError('abstract base class is abstract')

    def process(self, sourceFile, text_blocks, sequence, continuous_processor=None):
        diagrams = []

        for block in text_blocks:

            if not continuous_processor:
                log(1, "Rendering diagram for block... %s", sequence[0])

            try:
                diagram = self.DIAGRAM_CLASS(self, sourceFile, block, sequence[0])

            except Exception as e:
                log(1, repr(block))
                log(1, "Error rendering diagram for block: %s", e)
                sys.excepthook(*sys.exc_info())

            sequence[0] += 1
            rendered = diagram.generate()
            diagrams.append(rendered)

        return diagrams


class BaseViewer(object):
    def __str__(self):
        return "Sublime Base Viewer"

    def load(self):
        raise NotImplementedError('abstract base class is abstract')

    def view(self, filenames):
        raise NotImplementedError('abstract base class is abstract')
