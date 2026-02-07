package api.zahra.medsense.ui.theme

import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.runtime.Composable

private val DarkColorScheme = darkColorScheme(
    primary = ElectricBlue,
    secondary = HealingTeal,
    background = DeepSpace,
    surface = DeepSpace,
    onPrimary = DeepSpace,
    onSecondary = DeepSpace,
    onBackground = TextPrimary,
    onSurface = TextPrimary
)

@Composable
fun ZahraMedSenseTheme(
    content: @Composable () -> Unit
) {
    MaterialTheme(
        colorScheme = DarkColorScheme,
        typography = Typography, // We'll define this next
        content = content
    )
}
