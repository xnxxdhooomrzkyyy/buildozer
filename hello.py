from kivy.app import App
from kivy.uix.label import Label
from kivy.uix.boxlayout import BoxLayout


class HelloApp(App):
    def build(self):
        layout = BoxLayout(orientation='vertical')
        label = Label(
            text="Hello World from Kivy on Kali Moto!",
            font_size='24sp'
        )
        layout.add_widget(label)
        return layout


if __name__ == "__main__":
    HelloApp().run()
