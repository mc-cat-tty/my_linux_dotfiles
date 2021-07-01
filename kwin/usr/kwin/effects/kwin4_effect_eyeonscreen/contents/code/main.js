/********************************************************************
 KWin - the KDE window manager
 This file is part of the KDE project.

 Copyright (C) 2015 Thomas Lübking <thomas.luebking@gmail.com>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*********************************************************************/
/*global effect, effects, animate, animationTime, Effect, QEasingCurve */

"use strict";

var eyeOnScreenEffect = {
    duration: animationTime(250),
    loadConfig: function () {
        eyeOnScreenEffect.duration = animationTime(250);
    },
    delevateWindow: function(window) {
        if (window.desktopWindow) {
            if (window.eyeOnScreenShowsDesktop) {
                window.eyeOnScreenShowsDesktop = false;
                var stackingOrder = effects.stackingOrder;
                for (var i = 0; i < stackingOrder.length; ++i) {
                    var w = stackingOrder[i];
                    if (w.eyeOnScreenOpacityKeeper === undefined)
                        continue;
                    cancel(w.eyeOnScreenOpacityKeeper);
                    delete w.eyeOnScreenOpacityKeeper;
                }
            }
        } else if (window.elevatedByEyeOnScreen) {
            effects.setElevatedWindow(window, false);
            window.elevatedByEyeOnScreen = false;
        }
    },
    slurp: function (showing) {
        var stackingOrder = effects.stackingOrder;
        var screenGeo = effects.virtualScreenGeometry;
        var center = { value1: screenGeo.x + screenGeo.width/2,
                       value2: screenGeo.y + screenGeo.height/2 };
        for (var i = 0; i < stackingOrder.length; ++i) {
            var w = stackingOrder[i];
            if (!w.visible || !(showing || w.slurpedByEyeOnScreen)) {
                continue;
            }
            w.slurpedByEyeOnScreen = showing;
            if (w.desktopWindow) {
                // causes "seizures" because of opposing movements
                // var zoom = showing ? 0.8 : 1.2;
                var zoom = 0.8;
                w.eyeOnScreenShowsDesktop = showing;
                animate({
                    window: w,
                    duration: 2*eyeOnScreenEffect.duration, // "*2 for "bumper" transition
                    animations: [{
                        type: Effect.Scale,
                        curve: Effect.GaussianCurve,
                        to: zoom
                    }, {
                        type: Effect.Opacity,
                        curve: Effect.GaussianCurve,
                        to: 0.0
                    }]
                });
                if (showing) // (when not showing, pretty much everything would be above)
                    break; // ignore windows above the desktop
            } else {
                effects.setElevatedWindow(w, showing);
                if (showing) {
                    w.elevatedByEyeOnScreen = true;
                    if (w.dock) {
                        animate({
                            // this is a HACK - we need to trigger an animationEnded to delevate the dock in time, or it'll flicker :-(
                            // TODO? "var timer = new QTimer;" causes an error in effect scripts
                            window: w,
                            animations: [{
                            type: Effect.Opacity,
                            curve: QEasingCurve.Linear,
                            duration: eyeOnScreenEffect.duration,
                            to: 0.9
                            }]
                        });
                    } else {
                        animate({
                            window: w,
                            animations: [{
                                type: Effect.Scale,
                                curve: QEasingCurve.InCubic,
                                duration: eyeOnScreenEffect.duration,
                                to: 0.0
                            }, {
                                type: Effect.Position,
                                curve: QEasingCurve.InCubic,
                                duration: eyeOnScreenEffect.duration,
                                to: center
                            }]
                        });
                    }
                    w.eyeOnScreenOpacityKeeper = set({
                        window: w,
                        animations: [{
                        type: Effect.Opacity,
                        curve: QEasingCurve.InCubic,
                        duration: eyeOnScreenEffect.duration,
                        to: 0.0
                        }]
                    });
                } else {
                    w.elevatedByEyeOnScreen = false;
                    if (!w.dock) {
                        animate({
                            window: w,
                            duration: eyeOnScreenEffect.duration,
                            delay: eyeOnScreenEffect.duration,
                            animations: [{
                                type: Effect.Scale,
                                curve: QEasingCurve.OutCubic,
                                from: 0.0
                            }, {
                                type: Effect.Position,
                                curve: QEasingCurve.OutCubic,
                                from: center
                            }]
                        });
                    }
                    if (w.eyeOnScreenOpacityKeeper !== undefined) {
                        cancel(w.eyeOnScreenOpacityKeeper);
                        delete w.eyeOnScreenOpacityKeeper;
                    }
                    animate({
                        window: w,
                        duration: eyeOnScreenEffect.duration,
                        delay: eyeOnScreenEffect.duration,
                        animations: [{
                            type: Effect.Opacity,
                            curve: QEasingCurve.OutCubic,
                            duration: eyeOnScreenEffect.duration,
                            from: 0.0
                        }]
                    });
                }
            }
        }
    },
    init: function () {
        eyeOnScreenEffect.loadConfig();
        effects.showingDesktopChanged.connect(eyeOnScreenEffect.slurp);
        effect.animationEnded.connect(eyeOnScreenEffect.delevateWindow);
    }
};

eyeOnScreenEffect.init();
