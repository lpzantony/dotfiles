"""Tests for error visualizer."""
import imp
from os import path

from EasyClangComplete.plugin.error_vis import popup_error_vis
from EasyClangComplete.plugin.error_vis import phantom_error_vis
from EasyClangComplete.plugin.settings import settings_manager
from EasyClangComplete.plugin.settings import settings_storage
from EasyClangComplete.plugin import view_config

from EasyClangComplete.tests import gui_test_wrapper

imp.reload(gui_test_wrapper)
imp.reload(popup_error_vis)
imp.reload(phantom_error_vis)
imp.reload(settings_manager)
imp.reload(settings_storage)
imp.reload(view_config)

PopupErrorVis = popup_error_vis.PopupErrorVis
PhantomErrorVis = phantom_error_vis.PhantomErrorVis
GuiTestWrapper = gui_test_wrapper.GuiTestWrapper
SettingsManager = settings_manager.SettingsManager
SettingsStorage = settings_storage.SettingsStorage
ViewConfigManager = view_config.ViewConfigManager

PHANTOMS = SettingsStorage.PHANTOMS_STYLE
POPUPS = SettingsStorage.POPUPS_STYLE


class TestErrorVis:
    """Test error visualization."""

    def set_up_completer(self, error_style):
        """Utility method to set up a completer for the current view.

        Returns:
            BaseCompleter: completer for the current view.
        """
        manager = SettingsManager()
        settings = manager.settings_for_view(self.view)
        settings.use_libclang = self.use_libclang

        settings.errors_style = error_style

        view_config_manager = ViewConfigManager()
        view_config = view_config_manager.load_for_view(self.view, settings)
        completer = view_config.completer
        return completer

    def tear_down_completer(self):
        """Utility method to set up a completer for the current view.

        Returns:
            BaseCompleter: completer for the current view.
        """
        view_config_manager = ViewConfigManager()
        view_config_manager.clear_for_view(self.view.buffer_id())

    def test_phantoms_init(self):
        """Test that setup view correctly sets up the phantoms."""
        file_name = path.join(path.dirname(__file__),
                              'test_files',
                              'test.cpp')
        self.set_up_view(file_name)
        completer = self.set_up_completer(PHANTOMS)
        completer.error_vis.err_regions = {}
        self.assertIsNotNone(completer.error_vis)
        self.assertTrue(isinstance(completer.error_vis, PhantomErrorVis))
        self.tear_down_completer()
        self.tear_down()

    def test_popups_init(self):
        """Test that setup view correctly sets up the popup."""
        file_name = path.join(path.dirname(__file__),
                              'test_files',
                              'test.cpp')
        self.set_up_view(file_name)
        completer = self.set_up_completer(POPUPS)
        self.assertIsNotNone(completer.error_vis)
        self.assertTrue(isinstance(completer.error_vis, PopupErrorVis))
        self.tear_down_completer()
        self.tear_down()

    def test_generate_errors(self):
        """Test that errors get correctly generated and cleared."""
        for err_type in [PHANTOMS, POPUPS]:
            file_name = path.join(path.dirname(__file__),
                                  'test_files',
                                  'test.cpp')
            self.set_up_view(file_name)
            completer = self.set_up_completer(err_type)
            self.assertIsNotNone(completer.error_vis)
            err_dict = completer.error_vis.err_regions
            v_id = self.view.buffer_id()
            self.assertTrue(v_id in err_dict)
            self.assertEqual(len(err_dict[v_id]), 1)
            self.assertTrue(10 in err_dict[v_id])
            self.assertEqual(len(err_dict[v_id][10]), 1)
            self.assertEqual(err_dict[v_id][10][0]['row'], '10')
            self.assertEqual(err_dict[v_id][10][0]['col'], '3')
            expected_error = "expected unqualified-id"
            self.assertTrue(expected_error in err_dict[v_id][10][0]['error'])

            # not clear errors:
            completer.error_vis.clear(self.view)
            err_dict = completer.error_vis.err_regions
            self.assertFalse(v_id in err_dict)

            # cleanup
            self.tear_down_completer()
            self.tear_down()

    def test_show_phantoms(self):
        """Test that the phantoms are shown."""
        file_name = path.join(path.dirname(__file__),
                              'test_files',
                              'test.cpp')
        self.set_up_view(file_name)
        completer = self.set_up_completer(PHANTOMS)
        self.assertIsNotNone(completer.error_vis)
        phantom_sets = completer.error_vis.phantom_sets
        v_id = self.view.buffer_id()
        self.assertTrue(v_id in phantom_sets)
        self.tear_down_completer()
        self.tear_down()

    def test_popup_html(self):
        """Test html formatting for popups."""
        error_dict = {
            'error': "expected ';' at end of declaration",
            'severity': 3,
            'row': '6',
            'file': 'filename',
            'col': '25'
        }
        html_error = PopupErrorVis._as_html([error_dict])
        expected = """<body id="ecc_popup_error">
    <style>
        html {
            background-color: #883333;
            color: #EEEEEE;
        }
    </style>
    <b>Error:</b>
    <div>expected&nbsp;';'&nbsp;at&nbsp;end&nbsp;of&nbsp;declaration</div>
</body>
"""
        self.assertEqual(html_error, expected)

    def test_phantom_html(self):
        """Test html formatting for phantoms."""
        error_dict = {
            'error': "expected ';' at end of declaration",
            'severity': 3,
            'row': '6',
            'file': 'filename',
            'col': '25'
        }
        html_error = PhantomErrorVis._as_html([error_dict])
        expected = """<body id="ecc_phantom_error">
    <style>
        div.error {
            padding: 0.4rem 0 0.4rem 0.7rem;
            margin: 0.2rem 0;
            border-radius: 2px;
        }

        div.error span.message {
            padding-right: 0.7rem;
        }

        div.error a {
            text-decoration: inherit;
            padding: 0.35rem 0.7rem 0.45rem 0.8rem;
            position: relative;
            bottom: 0.05rem;
            border-radius: 0 2px 2px 0;
            font-weight: bold;
        }
        html.dark div.error a {
            color: #CCCCCC;
        }
        html.light div.error a {
            color: #222222;
        }
    </style>
    <div class="error">
      <span class="message">
      expected&nbsp;';'&nbsp;at&nbsp;end&nbsp;of&nbsp;declaration
      </span>
      <a href=hide>❌</a>
    </div>
</body>
"""
        self.assertEqual(html_error, expected)


class TestErrorVisBin(TestErrorVis, GuiTestWrapper):
    """Test class for the binary based completer."""
    use_libclang = False


class TestErrorVisLib(TestErrorVis, GuiTestWrapper):
    """Test class for the binary based completer."""
    use_libclang = True
