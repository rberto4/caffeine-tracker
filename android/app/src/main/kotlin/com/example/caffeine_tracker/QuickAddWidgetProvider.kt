package com.example.caffeine_tracker

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class QuickAddWidgetProvider : AppWidgetProvider() {
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
        val views = RemoteViews(context.packageName, R.layout.quick_add_widget)

        // Update beverages data
        for (i in 0..3) {
            val beverageId = widgetData.getString("beverage_${i}_id", "") ?: ""
            val beverageName = widgetData.getString("beverage_${i}_name", "Coffee") ?: "Coffee"
            
            // Handle caffeine as float to avoid casting issues
            val beverageCaffeine = try {
                widgetData.getFloat("beverage_${i}_caffeine", 0f)
            } catch (e: ClassCastException) {
                0f
            }
            
            // Handle color as string to avoid casting issues
            val beverageColor = try {
                val colorString = widgetData.getString("beverage_${i}_color", "")
                if (colorString?.isNotEmpty() == true) {
                    colorString.toInt()
                } else {
                    Color.parseColor("#FF6B35")
                }
            } catch (e: Exception) {
                Color.parseColor("#FF6B35")
            }

            if (beverageId.isNotEmpty()) {
                // Map i to the correct resource IDs
                val nameId = when (i) {
                    0 -> R.id.beverage_name_0
                    1 -> R.id.beverage_name_1
                    2 -> R.id.beverage_name_2
                    3 -> R.id.beverage_name_3
                    else -> R.id.beverage_name_0
                }
                
                val caffeineId = when (i) {
                    0 -> R.id.beverage_caffeine_0
                    1 -> R.id.beverage_caffeine_1
                    2 -> R.id.beverage_caffeine_2
                    3 -> R.id.beverage_caffeine_3
                    else -> R.id.beverage_caffeine_0
                }
                
                val buttonId = when (i) {
                    0 -> R.id.beverage_button_0
                    1 -> R.id.beverage_button_1
                    2 -> R.id.beverage_button_2
                    3 -> R.id.beverage_button_3
                    else -> R.id.beverage_button_0
                }

                views.setTextViewText(nameId, beverageName)
                views.setTextViewText(caffeineId, "${beverageCaffeine.toInt()}mg")

                // Set background color based on beverage color
                try {
                    views.setInt(buttonId, "setBackgroundColor", beverageColor)
                } catch (e: Exception) {
                    // Fallback to default color
                    views.setInt(buttonId, "setBackgroundColor", Color.parseColor("#FF6B35"))
                }

                // Set click listener to add beverage
                val intent = Intent(context, MainActivity::class.java).apply {
                    putExtra("action", "add_beverage")
                    putExtra("beverage_id", beverageId)
                }
                val pendingIntent = PendingIntent.getActivity(
                    context,
                    beverageId.hashCode(), // Use beverage ID hash as request code for uniqueness
                    intent,
                    PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                )
                views.setOnClickPendingIntent(buttonId, pendingIntent)
            }
        }

        // Update the widget
        appWidgetManager.updateAppWidget(appWidgetId, views)
    }
}