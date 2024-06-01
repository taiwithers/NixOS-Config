import dbus
import dbus.service
from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib

# dbus inter process system handles notifications on linux desktops
# notifications typically go through an org.freedesktop.Notifications bus

class NotificationServer(dbus.service.Object):
	def __init__(self):
		bus_name = dbus.service.BusName('org.freedesktop.Notifications', bus=dbus.SessionBus())
		dbus.service.Object.__init__(self, bus_name, '/org/freedesktop/Notifications')

	@dbus.service.method('org.freedesktop.Notifications', in_signature='susssasa{ss}i', out_signature='u')
	def Notify(self, app_name, replaces_id, app_icon, summary, body, actions, hints, timeout):
		print('Recieved Notification:')
		print(f'\t{app_name=}\n\t{replaces_id=}\n\t{app_icon=}\n\t{summary=}\n\t{body=}\n\t{actions=}\n\t{hints=}\n\t{timeout=}\n\t')
		return 0

	@dbus.service.method('org.freedesktop.Notifications', out_signature='ssss')
	def GetServerInformation(self):
		return ('Custom Notification Server', 'Example Notification Server', '1.0', '1.2')

DBusGMainLoop(set_as_default=True)

if __name__ == '__main__':
	server = NotificationServer()
	mainloop = GLib.MainLoop()
	mainloop.run()