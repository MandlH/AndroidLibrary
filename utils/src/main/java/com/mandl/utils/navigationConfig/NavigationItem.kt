package navigationConfig

import android.content.Context
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity

class NavigationItem(private val classToMove: Class<*>, private  var id: Int) : AppCompatActivity() {

    private var intent: Intent? = null

    fun setIntent(context: Context) {
        intent = Intent(context, classToMove)
    }

    fun getId(): Int {
        return id
    }

    fun setId(id: Int) {
        this.id = id
    }

    override fun getIntent(): Intent? {
        return intent
    }

    override fun setIntent(intent: Intent) {
        this.intent = intent
    }
}