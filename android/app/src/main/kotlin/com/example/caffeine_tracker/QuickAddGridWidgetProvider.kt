package com.example.caffeine_tracker

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

/**
 * Widget 4x2 che mostra tutte e 4 le bevande della quick add grid in un layout 2x2
 * Ogni bevanda può essere toccata per aggiungere un'assunzione
 */
class QuickAddGridWidgetProvider : AppWidgetProvider() {
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
        val views = RemoteViews(context.packageName, R.layout.quick_add_grid_widget)

        // Update all 4 beverages
        val buttonIds = arrayOf(
            R.id.beverage_card_0,
            R.id.beverage_card_1,
            R.id.beverage_card_2,
            R.id.beverage_card_3
        )

        val nameIds = arrayOf(
            R.id.beverage_grid_name_0,
            R.id.beverage_grid_name_1,
            R.id.beverage_grid_name_2,
            R.id.beverage_grid_name_3
        )

        val caffeineIds = arrayOf(
            R.id.beverage_grid_caffeine_0,
            R.id.beverage_grid_caffeine_1,
            R.id.beverage_grid_caffeine_2,
            R.id.beverage_grid_caffeine_3
        )

        for (i in 0..3) {
            val beverageId = widgetData.getString("beverage_${i}_id", "") ?: ""
            val beverageName = widgetData.getString("beverage_${i}_name", getCoffeeName(i)) ?: getCoffeeName(i)
            
            val beverageCaffeine = try {
                widgetData.getFloat("beverage_${i}_caffeine", 0f)
            } catch (e: ClassCastException) {
                0f
            }

            // Update text views
            views.setTextViewText(nameIds[i], beverageName)
            views.setTextViewText(caffeineIds[i], "${beverageCaffeine.toInt()}mg")

            // Set click listener
            val intent = Intent(context, MainActivity::class.java).apply {
                putExtra("action", "add_beverage")
                putExtra("beverage_id", beverageId)
            }
            val pendingIntent = PendingIntent.getActivity(
                context,
                beverageId.hashCode(),
                intent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(buttonIds[i], pendingIntent)
        }

        // Update the widget
        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    private fun getCoffeeName(index: Int): String {
        return when (index) {
            0 -> "Caffè"
            1 -> "Tè"
            2 -> "Energy"
            3 -> "Cola"
            else -> "Bevanda"
        }
    }
}
