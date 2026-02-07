#include <QApplication>
#include <QMainWindow>
#include <QLabel>

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);
    QMainWindow window;
    window.setWindowTitle("KDE/Qt6 Template App");
    QLabel *label = new QLabel("Hello from KDE/Qt6!", &window);
    label->setAlignment(Qt::AlignCenter);
    window.setCentralWidget(label);
    window.resize(400, 200);
    window.show();
    return app.exec();
}
