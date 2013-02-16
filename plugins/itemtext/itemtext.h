/*
    Copyright (c) 2013, Lukas Holecek <hluk@email.cz>

    This file is part of CopyQ.

    CopyQ is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    CopyQ is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with CopyQ.  If not, see <http://www.gnu.org/licenses/>.
*/

#ifndef ITEMTEXT_H
#define ITEMTEXT_H

#include "itemwidget.h"

#include <QTextDocument>
#include <QTextEdit>

class ItemText : public QTextEdit, public ItemWidget
{
    Q_OBJECT

public:
    ItemText(QWidget *parent);

    QWidget *widget() { return this; }

    virtual void setData(const QModelIndex &index);

    void setRichTextData(const QString &text);

    void setTextData(const QString &text);

protected:
    virtual void highlight(const QRegExp &re, const QFont &highlightFont,
                           const QPalette &highlightPalette);

    virtual void updateSize();

    virtual void mousePressEvent(QMouseEvent *e);

    virtual void mouseDoubleClickEvent(QMouseEvent *e);

    virtual void contextMenuEvent(QContextMenuEvent *e);

private:
    QTextDocument m_textDocument;
    QTextDocument m_searchTextDocument;
    Qt::TextFormat m_textFormat;
};

class ItemTextLoader : public QObject, public ItemLoaderInterface
{
    Q_OBJECT
    Q_PLUGIN_METADATA(IID COPYQ_PLUGIN_ITEM_LOADER_ID)
    Q_INTERFACES(ItemLoaderInterface)

public:
    virtual ItemWidget *create(const QModelIndex &index, QWidget *parent) const;

    virtual QString name() const { return tr("Text Items"); }
    virtual QString author() const { return QString(); }
    virtual QString description() const { return tr("Display plain text and simple HTML items."); }

    virtual QStringList formatsToSave() const;
};

#endif // ITEMTEXT_H
