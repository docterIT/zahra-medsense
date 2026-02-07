package api.zahra.medsense.ui.screens

import androidx.compose.foundation.layout.*
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import api.zahra.medsense.ui.components.GlassCard
import api.zahra.medsense.ui.theme.ElectricBlue
import api.zahra.medsense.ui.theme.TextSecondary

@Composable
fun DashboardScreen() {
    Column(
        modifier = Modifier
            .fillMaxSize()
            .padding(24.dp)
    ) {
        Text(
            text = "Zahra MedSense",
            style = api.zahra.medsense.ui.theme.Typography.headlineLarge,
            color = Color.White
        )
        Text(
            text = "Zenith AI for Health & Recovery",
            style = api.zahra.medsense.ui.theme.Typography.bodyLarge,
            color = ElectricBlue
        )
        
        Spacer(modifier = Modifier.height(40.dp))
        
        Text(
            text = "DASHBOARD",
            style = api.zahra.medsense.ui.theme.Typography.titleMedium,
            color = TextSecondary
        )
        
        Spacer(modifier = Modifier.height(16.dp))
        
        GlassCard(
            modifier = Modifier.fillMaxWidth()
        ) {
            Column {
                Text(
                    text = "Parkinson's Screening",
                    style = api.zahra.medsense.ui.theme.Typography.titleMedium,
                    color = Color.White
                )
                Text(
                    text = "Last analysis: 2 days ago",
                    style = api.zahra.medsense.ui.theme.Typography.bodyLarge,
                    color = TextSecondary
                )
            }
        }
        
        Spacer(modifier = Modifier.height(16.dp))
        
        GlassCard(
            modifier = Modifier.fillMaxWidth()
        ) {
            Column {
                Text(
                    text = "Stroke Analysis",
                    style = api.zahra.medsense.ui.theme.Typography.titleMedium,
                    color = Color.White
                )
                Text(
                    text = "Start voice recording test",
                    style = api.zahra.medsense.ui.theme.Typography.bodyLarge,
                    color = api.zahra.medsense.ui.theme.HealingTeal
                )
            }
        }
    }
}
