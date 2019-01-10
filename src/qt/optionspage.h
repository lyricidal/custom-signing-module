// Copyright (c) 2011-2014 The Bitcoin developers
// Distributed under the MIT/X11 software license, see the accompanying
// file COPYING or http://www.opensource.org/licenses/mit-license.php.

#ifndef BITCOIN_QT_OPTIONSPAGE_H
#define BITCOIN_QT_OPTIONSPAGE_H

#include "guiutil.h"

#include <QDialog>
#include <QHeaderView>
#include <QItemSelection>
#include <QKeyEvent>
#include <QMenu>
#include <QPoint>
#include <QVariant>
#include <QSettings>

class OptionsModel;
class WalletModel;

namespace Ui
{
class OptionsPage;
}

QT_BEGIN_NAMESPACE
class QModelIndex;
class QDataWidgetMapper;
QT_END_NAMESPACE

/** Dialog for options page */
class OptionsPage : public QDialog
{
    Q_OBJECT

public:
    explicit OptionsPage(QWidget* parent = 0);
    ~OptionsPage();

    void setModel(WalletModel* model);
    void setMapper();
    bool matchNewPasswords();

public slots:

protected:
    virtual void keyPressEvent(QKeyEvent* event);

private:
    Ui::OptionsPage* ui;
    GUIUtil::TableViewLastColumnResizingFixer* columnResizingFixer;
    WalletModel* model;
    OptionsModel* options;
    QDataWidgetMapper* mapper;
    QSettings settings;
    QMenu* contextMenu;
    virtual void resizeEvent(QResizeEvent* event);

private slots:
    void validateNewPass();
    void validateNewPassRepeat();
    void on_pushButtonDarkMode_clicked();
    void on_pushButtonLightMode_clicked();
    void on_pushButtonPassword_clicked();
};

#endif // BITCOIN_QT_OPTIONSPAGE_H
