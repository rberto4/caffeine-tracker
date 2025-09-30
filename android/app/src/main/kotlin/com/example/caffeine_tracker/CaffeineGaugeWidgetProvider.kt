package com.example.caffeine_tracker

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class CaffeineGaugeWidgetProvider : AppWidgetProvider() {
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
        val views = RemoteViews(context.packageName, R.layout.caffeine_gauge_widget)

        // Get data from Flutter with type safety
        val currentCaffeine = try {
            widgetData.getFloat("current_caffeine", 0f)
        } catch (e: ClassCastException) {
            0f
        }
        
        val maxCaffeine = try {
            widgetData.getFloat("max_caffeine", 400f)
        } catch (e: ClassCastException) {
            400f
        }
        
        val percentage = try {
            widgetData.getFloat("caffeine_percentage", 0f)
        } catch (e: ClassCastException) {
            0f
        }
        
        val totalIntakes = widgetData.getInt("total_intakes", 0)

        // Update text views
        views.setTextViewText(R.id.current_caffeine, "${currentCaffeine.toInt()}mg")
        views.setTextViewText(R.id.max_caffeine, "/ ${maxCaffeine.toInt()}mg")
        views.setTextViewText(R.id.intake_count, "$totalIntakes assunzioni oggi")

        // Update greeting based on time
        val greeting = getTimeBasedGreeting()
        views.setTextViewText(R.id.greeting_text, greeting)

        // Set click listener to open app
        val intent = Intent(context, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
            context, 
            0, 
            intent, 
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        views.setOnClickPendingIntent(R.id.gauge_container, pendingIntent)

        // Update progress color based on percentage
        val progressColor = when {
            percentage <= 25 -> android.graphics.Color.parseColor("#4CAF50") // Green
            percentage <= 50 -> android.graphics.Color.parseColor("#FFEB3B") // Yellow
            percentage <= 75 -> android.graphics.Color.parseColor("#FF9800") // Orange
            else -> android.graphics.Color.parseColor("#F44336") // Red
        }

        // Update the widget
        appWidgetManager.updateAppWidget(appWidgetId, views)
    }

    private fun getTimeBasedGreeting(): String {
        val hour = java.util.Calendar.getInstance().get(java.util.Calendar.HOUR_OF_DAY)
        return when {
            hour < 12 -> "Buongiorno ☕️"
            hour < 17 -> "Buon pomeriggio ☕️"
            else -> "Buonasera ☕️"
        }
    }
}