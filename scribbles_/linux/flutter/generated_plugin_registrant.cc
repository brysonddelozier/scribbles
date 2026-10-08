//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <app_links_linux/app_links_plugin_linux.h>
#include <desktop_webview_auth/desktop_webview_auth_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) app_links_linux_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "AppLinksPluginLinux");
  app_links_plugin_linux_register_with_registrar(app_links_linux_registrar);
  g_autoptr(FlPluginRegistrar) desktop_webview_auth_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "DesktopWebviewAuthPlugin");
  desktop_webview_auth_plugin_register_with_registrar(desktop_webview_auth_registrar);
}
