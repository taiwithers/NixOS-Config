import dbus
import dbus.service
from dbus.mainloop.glib import DBusGMainLoop
from gi.repository import GLib

# dbus inter process system handles notifications on linux desktops
# notifications typically go through an org.freedesktop.Notifications bus
class Notification:
	def __init__(self, summary, body, icon):
		self.summary = summary
		self.body = body
		self.icon = icon

current_notifications = []
# def print_state():
# 	message = 'Current State:'
# 	for item in current_notifications:
# 		message += f'\n{item}'
# 	print(message, flush=True)

def print_state_yuck():
	all_notifications_yuck = ''
	icon_size = 80
	text_width = 100

	for item in current_notifications:
		icon = f'''
				(image :image-width {icon_size}
					   :image-height {icon_size}
				  	   : path '{item.icon or ''}')
				'''
		summary = f'''
				   (label :width {text_width}
				   		  :wrap true
				   		  :text '{item.summary or ''}')
				   '''
		body = f'''
				(label :width {text_width}
				   	   :wrap true
				   	   :text '{item.body or ''}')
				'''
		yuck = f'''
				(button :class 'notification-button'
						(box :orientation 'horizontal'
							 :space-evenly false
							 {image}
							 (box :orientation 'vertical'
							 	  {summary}
							 	  {body}
							 )
						)
				)
				'''

		all_notifications_yuck += yuck.replace('\n', ' ')

	print(fr'(box :orientation 'vertical'\n {all_notifications_yuck or ''})', flush=True)

def remove_object(notification):
	time.sleep(10)
	current_notifications.remove(notification)
	print_state_yuck()

def add_object(notification):
	current_notifications.insert(0, notification)
	print_state_yuck()
	timer_thread = threading.Thread(target=remove_object, args=(notif,))
	timer_thread.start()


class NotificationServer(dbus.service.Object):
	def __init__(self):
		bus_name = dbus.service.BusName('org.freedesktop.Notifications', bus=dbus.SessionBus())
		dbus.service.Object.__init__(self, bus_name, '/org/freedesktop/Notifications')

	@dbus.service.method('org.freedesktop.Notifications', in_signature='susssasa{ss}i', out_signature='u')
	def Notify(self, app_name, replaces_id, app_icon, summary, body, actions, hints, timeout):
		add_object(notification(summary, body, app_icon))
		return 0

	@dbus.service.method('org.freedesktop.Notifications', out_signature='ssss')
	def GetServerInformation(self):
		return ('Custom Notification Server', 'Example Notification Server', '1.0', '1.2')

DBusGMainLoop(set_as_default=True)



if __name__ == '__main__':
	server = NotificationServer()
	mainloop = GLib.MainLoop()
	mainloop.run()