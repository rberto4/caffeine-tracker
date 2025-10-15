package com.example.caffeine_tracker

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

/**
 * Widget 2x2 che mostra una singola bevanda della quick add grid
 * Al tocco, aggiunge un'assunzione di quella bevanda
 */
class SingleBeverageWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    private fun updateAppWidget(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetId: Int
    ) {
        val widgetData = HomeWidgetPlugin.getData(context)
        val views = RemoteViews(context.packageName, R.layout.single_beverage_widget)

        // Determina quale bevanda mostrare per questo widget (in base all'ID del widget)
        // Per ora usiamo la bevanda 0 (prima), ma può essere configurabile
        val beverageIndex = widgetData.getInt("widget_${appWidgetId}_beverage_index", 0)

        // Carica i dati della bevanda
        val beverageId = widgetData.getString("beverage_${beverageIndex}_id", "") ?: ""
        val beverageName = widgetData.getString("beverage_${beverageIndex}_name", "Caffè") ?: "Caffè"
        
        val beverageCaffeine = try {
            widgetData.getFloat("beverage_${beverageIndex}_caffeine", 95f)
        } catch (e: ClassCastException) {
            95f
        }

        val beverageVolume = try {
            widgetData.getFloat("beverage_${beverageIndex}_volume", 250f)
        } catch (e: ClassCastException) {
            250f
        }
        
        val beverageColor = try {
            val colorString = widgetData.getString("beverage_${beverageIndex}_color", "")
            if (colorString?.isNotEmpty() == true) {
                colorString.toInt()
            } else {
                Color.parseColor("#FF6B35")
            }
        } catch (e: Exception) {
            Color.parseColor("#FF6B35")
        }

        // Aggiorna i dati nel widget
        views.setTextViewText(R.id.beverage_name, beverageName)
        views.setTextViewText(R.id.beverage_caffeine, "${beverageCaffeine.toInt()}mg")
        views.setTextViewText(R.id.beverage_volume, "${beverageVolume.toInt()}ml")
        
        // Imposta il colore di sfondo
        try {
            views.setInt(R.id.widget_container, "setBackgroundColor", beverageColor)
        } catch (e: Exception) {
            views.setInt(R.id.widget_container, "setBackgroundColor", Color.parseColor("#FF6B35"))
        }

        // Set click listener to add beverage intake
        val intent = Intent(context, MainActivity::class.java).apply {
            putExtra("action", "add_beverage")
            putExtra("beverage_id", beverageId)
        }
        val pendingIntent = PendingIntent.getActivity(
            context,
            appWidgetId, // Use widget ID as request code for uniqueness
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        views.setOnClickPendingIntent(R.id.widget_container, pendingIntent)

        // Update the widget
        appWidgetManager.updateAppWidget(appWidgetId, views)
    }
}
