#ifndef NATIVEEVENTFILTER_H
#define NATIVEEVENTFILTER_H
#pragma once

#include <QAbstractNativeEventFilter>
#include <QByteArray>
#include <windows.h>
#include <windowsx.h>

class NativeEventFilter : public QAbstractNativeEventFilter {
public:
    bool nativeEventFilter(const QByteArray &eventType, void *message, qintptr *result) override {
        if (eventType == QByteArrayLiteral("windows_generic_MSG")) {
            MSG* msg = static_cast<MSG*>(message);

            // Разворачивание с учётом панели задач
            if (msg->message == WM_GETMINMAXINFO) {
                MINMAXINFO* mmi = reinterpret_cast<MINMAXINFO*>(msg->lParam);
                mmi->ptMinTrackSize.x = 1280;
                mmi->ptMinTrackSize.y = 720;
                HMONITOR monitor = MonitorFromWindow(msg->hwnd, MONITOR_DEFAULTTONEAREST);
                MONITORINFO monitorInfo = {};
                monitorInfo.cbSize = sizeof(MONITORINFO);
                if (GetMonitorInfo(monitor, &monitorInfo)) {
                    RECT work = monitorInfo.rcWork;
                    RECT monitorRect = monitorInfo.rcMonitor;
                    mmi->ptMaxPosition.x = work.left - monitorRect.left;
                    mmi->ptMaxPosition.y = work.top - monitorRect.top;
                    mmi->ptMaxSize.x = work.right - work.left;
                    mmi->ptMaxSize.y = work.bottom - work.top;
                    *result = 0;
                    return true;
                }
            }

            // Обработка изменения размера по краям и углам
            if (msg->message == WM_NCHITTEST) {
                const LONG borderWidth = 8; // ширина чувствительной зоны
                RECT winRect;
                GetWindowRect(msg->hwnd, &winRect);

                const LONG x = GET_X_LPARAM(msg->lParam);
                const LONG y = GET_Y_LPARAM(msg->lParam);

                const bool resizeWidth = true;
                const bool resizeHeight = true;

                if (resizeWidth) {
                    // Левая граница
                    if (x >= winRect.left && x < winRect.left + borderWidth) {
                        if (resizeHeight) {
                            // Верхний левый угол
                            if (y >= winRect.top && y < winRect.top + borderWidth) {
                                *result = HTTOPLEFT;
                                return true;
                            }
                            // Нижний левый угол
                            if (y <= winRect.bottom && y > winRect.bottom - borderWidth) {
                                *result = HTBOTTOMLEFT;
                                return true;
                            }
                        }
                        *result = HTLEFT;
                        return true;
                    }

                    // Правая граница
                    if (x <= winRect.right && x > winRect.right - borderWidth) {
                        if (resizeHeight) {
                            // Верхний правый угол
                            if (y >= winRect.top && y < winRect.top + borderWidth) {
                                *result = HTTOPRIGHT;
                                return true;
                            }
                            // Нижний правый угол
                            if (y <= winRect.bottom && y > winRect.bottom - borderWidth) {
                                *result = HTBOTTOMRIGHT;
                                return true;
                            }
                        }
                        *result = HTRIGHT;
                        return true;
                    }
                }

                if (resizeHeight) {
                    // Верхняя граница
                    if (y >= winRect.top && y < winRect.top + borderWidth) {
                        *result = HTTOP;
                        return true;
                    }
                    // Нижняя граница
                    if (y <= winRect.bottom && y > winRect.bottom - borderWidth) {
                        *result = HTBOTTOM;
                        return true;
                    }
                }

                // Если не край — не обрабатываем
            }
        }
        return false;
    }
};

#endif // NATIVEEVENTFILTER_H

