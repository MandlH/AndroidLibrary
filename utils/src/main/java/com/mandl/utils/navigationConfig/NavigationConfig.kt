package navigationConfig

import android.content.Context
import java.lang.ref.WeakReference

class NavigationConfig private constructor(context: Context, private val listOfNavigationItems: MutableList<NavigationItem> = mutableListOf()) {

    private val contextRef: WeakReference<Context> = WeakReference(context)

    init {
        setNavigationItems()
    }

    fun addNavigationItem(item: NavigationItem) {
        listOfNavigationItems.add(item)
        contextRef.get()?.let { item.setIntent(it) }
    }

    fun addNavigationItems(items: List<NavigationItem>) {
        listOfNavigationItems.addAll(items)
        setNavigationItems()
    }

    fun updateIntents() {
        setNavigationItems()
    }


    private fun setNavigationItems() {
        listOfNavigationItems.forEach { contextRef.get()?.let { it1 -> it.setIntent(it1) } }
    }

    fun getListOfNavigationItems(): List<NavigationItem> {
        return listOfNavigationItems;
    }

    companion object {
        @Volatile
        private var instance: NavigationConfig? = null

        fun getInstance(context: Context): NavigationConfig {
            return instance ?: synchronized(this) {
                instance ?: NavigationConfig(context.applicationContext).also { instance = it }
            }
        }
    }
}