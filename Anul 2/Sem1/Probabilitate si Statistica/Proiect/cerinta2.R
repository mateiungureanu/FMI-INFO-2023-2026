library(shiny)

# Definirea interfetei grafice a aplicatiei
ui <- fluidPage(
  titlePanel("Aplicatie Shiny: Functii de Repartitie si Densitati"),
  sidebarLayout(
    sidebarPanel(
      tabsetPanel(
        id = "main_tabs",
        # Tab-ul pentru functiile de repartitie (A)
        tabPanel("Functii de Repartitie (A)", value = "A",
                 selectInput("distribution", "Alege distributia:",
                             choices = c("Normala (N(0,1))" = "normal",
                                         "Normala (N(μ,σ^2))" = "normal_custom",
                                         "Exponentiala" = "exponential",
                                         "Poisson" = "poisson",
                                         "Binomiala" = "binomial")),
                 # Afiseaza input-uri suplimentare in functie de distributia selectata
                 conditionalPanel(
                   condition = "input.distribution == 'normal'",
                   selectInput("variable", "Alege variabila:",
                               choices = c("X" = "X",
                                           "3-2X" = "3-2X",
                                           "X^2" = "X^2",
                                           "Suma de la 1 la n din Xi" = "Suma X",
                                           "Suma de la 1 la n din (Xi)^2" = "Suma X^2"
                               ))
                 ),
                 conditionalPanel(
                   condition = "input.distribution == 'normal_custom'",
                   selectInput("variable", "Alege variabila:",
                               choices = c("X" = "X",
                                           "3-2X" = "3-2X",
                                           "X^2" = "X^2",
                                           "Suma de la 1 la n din Xi" = "Suma X",
                                           "Suma de la 1 la n din (Xi)^2" = "Suma X^2"
                               )),
                   numericInput("mean", "Media (μ):", value = 0),
                   numericInput("sd", "Deviatia standard (σ):", value = 1, min = 0.01)
                 ),
                 conditionalPanel(
                   condition = "input.distribution == 'exponential'",
                   selectInput("variable", "Alege variabila:",
                               choices = c("X" = "X",
                                           "2+5X" = "2+5X",
                                           "X^2" = "X^2",
                                           "Suma de la 1 la n din Xi" = "Suma X"
                               )),
                   numericInput("lambda_exp", "Lambda (λ):", value = 1, min = 0.01)
                 ),
                 conditionalPanel(
                   condition = "input.distribution == 'poisson'",
                   selectInput("variable", "Alege variabila:",
                               choices = c("X" = "X",
                                           "3X-2" = "3X-2",
                                           "X^2" = "X^2",
                                           "Suma de la 1 la n din Xi" = "Suma X"
                               )),
                   numericInput("lambda_pois", "Lambda (λ):", value = 1, min = 0.01)
                 ),
                 conditionalPanel(
                   condition = "input.distribution == 'binomial'",
                   selectInput("variable", "Alege variabila:",
                               choices = c("X" = "X",
                                           "5X-4" = "5X-4",
                                           "X^3" = "X^3",
                                           "Suma de la 1 la n din Xi" = "Suma X"
                               )),
                   numericInput("n", "Numar de incercari (n):", value = 10, min = 1),
                   numericInput("p", "Probabilitate (p):", value = 0.5, min = 0, max = 1)
                 ),
                 # Selecteaza numarul de variabile generate si genereaza graficul
                 numericInput("nr", "Numar de variabile aleatoare (nr):", value = 1000, min = 1),
                 actionButton("generateA", "Genereaza graficul")
        ),
        # Tab-ul pentru functiile de densitate (B)
        tabPanel("Functii de Densitate (B)", value = "B",
                 selectInput("functionB", "Alege functia:",
                             choices = c("f(x) = cx^4" = "fx1",
                                         "f(x) = ax + bx^2" = "fx2",
                                         "f(x) = 4 / (x(x+1)(x+2))" = "fx3",
                                         "f(x) = log(x/(x+1))" = "fx4",
                                         "f(x) = (θ^2 / (1+θ))(1+x)e^(-θx))" = "fx5",
                                         "f(x) = 1/3 * e^x pentru x<0, 1/3 pentru 0<=x<1, 1/3 * e^(-(x-1)) pentru x>=1" = "fx6",
                                         "f(x) = 1 / (π(1+x^2))" = "fx7")),
                 # Input-uri suplimentare pentru functiile care au parametri
                 conditionalPanel(
                   condition = "input.functionB == 'fx2'",
                   numericInput("a", "Parametrul a:", value = 1)
                 ),
                 conditionalPanel(
                   condition = "input.functionB == 'fx5'",
                   numericInput("theta", "Parametrul θ:", value = 1, min = 0.01)
                 ),
                 # Buton pentru generarea functiei si calcularea mediei si variantei
                 actionButton("generateB", "Genereaza functia si calculeaza")
        )
      )
    ),
    # Panoul principal
    mainPanel(
      conditionalPanel(
        condition = "input.main_tabs === 'A'",
        plotOutput("plotA")
      ),
      conditionalPanel(
        condition = "input.main_tabs === 'B'",
        plotOutput("plotB"),
        verbatimTextOutput("statsB")
      )
    )
  )
)

# Definirea serverului
server <- function(input, output) {
  # Generarea functiilor de repartitie
  observeEvent(input$generateA, {
    output$plotA <- renderPlot({
      nr <- input$nr
      X <- NULL
      
      # Generarea variabilelor in functie de distributia selectata
      if (input$distribution == "normal") {
        X <- rnorm(nr, mean = 0, sd = 1)
      } else if (input$distribution == "normal_custom") {
        X <- rnorm(nr, mean = input$mean, sd = input$sd)
      } else if (input$distribution == "exponential") {
        X <- rexp(nr, rate = input$lambda_exp)
      } else if (input$distribution == "poisson") {
        X <- rpois(nr, lambda = input$lambda_pois)
      } else if (input$distribution == "binomial") {
        X <- rbinom(nr, size = input$n, prob = input$p)
      }
      
      # Transformarea variabilei
      if (input$variable == "X") {
        Y <- X
      } else if (input$variable == "3-2X") {
        Y <- 3 - 2 * X
      } else if (input$variable == "2+5X") {
        Y <- 2 + 5 * X
      } else if (input$variable == "3X-2") {
        Y <- 3 * X - 2
      } else if (input$variable == "5X-4") {
        Y <- 5 * X - 4
      } else if (input$variable == "X^2") {
        Y <- X^2
      } else if (input$variable == "X^3") {
        Y <- X^3
      } else if (input$variable == "Suma X") {
        Y <- cumsum(X)
      } else if (input$variable == "Suma X^2") {
        Y <- cumsum(X^2)
      }
      
      # Calculul si afisarea functiei de repartitie empirica
      F <- ecdf(Y)
      plot(F, main = "Functia de Repartitie Empirica", xlab = "Y", ylab = "F(Y)", col = "blue", lwd = 2)
    })
  })
  
  # Generarea functiilor de densitate
  observeEvent(input$generateB, {
    output$plotB <- renderPlot({
      # Initializarea lui x si normalizarea lui f
      if (input$functionB == "fx1") {
        x <- seq(0, 2, length.out = 1000)
        c <- 5 / 32
        f <- c * x^4
      } else if (input$functionB == "fx2") {
        x <- seq(0, 1, length.out = 1000)
        b <- 3 * (1 - input$a / 2)
        f <- (input$a * x + b * x^2)
      } else if (input$functionB == "fx3") {
        x <- seq(1, 100)
        f <- 4 / (x * (x + 1) * (x + 2))
        f <- f / sum(f)
      } else if (input$functionB == "fx4") {
        x <- seq(1, 9)
        f <- log(x / (x + 1))
        f <- f / sum(f)
      } else if (input$functionB == "fx5") {
        x <- seq(0, 10, length.out = 1000)
        f <- (input$theta^2 / (1 + input$theta)) * (1 + x) * exp(-input$theta * x)
        norm_factor <- 1 / integrate(function(x) (input$theta^2 / (1 + input$theta)) * (1 + x) * exp(-input$theta * x), 0, Inf)$value
        f <- norm_factor * f
      } else if (input$functionB == "fx6") {
        x <- seq(-5, 5, length.out = 1000)
        norm_factor <- 1 / (
          integrate(function(x) (1/3) * exp(x), -Inf, 0)$value + 
          integrate(function(x) (1/3) * x^0, 0, 1)$value + 
          integrate(function(x) (1/3) * exp(-(x - 1)), 1, Inf)$value)
        f <- ifelse(x < 0, norm_factor * (1/3) * exp(x),
                    ifelse(x >= 0 & x < 1, norm_factor * (1/3),
                           norm_factor * (1/3) * exp(-(x - 1))))
      } else if (input$functionB == "fx7") {
        x <- seq(-5, 5, length.out = 1000)
        f <- 1 / (pi * (1 + x^2))
      }
      
      # Afisarea graficului
      if (input$functionB %in% c("fx3", "fx4")) {
        plot(x, f, type = "p", main = "Graficul functiei", xlab = "x", ylab = "f(x)", col = "red", lwd = 2)
      } else {
        plot(x, f, type = "l", main = "Graficul functiei", xlab = "x", ylab = "f(x)", col = "red", lwd = 2)
      }
    })
    
    output$statsB <- renderText({
      # Calculul mediei si variantei
      if (input$functionB == "fx1") {
        x <- seq(0, 2, length.out = 1000)
        c <- 5 / 32
        mean_val <- integrate(function(x) x * c * x^4, 0, 2)$value
        var_val <- integrate(function(x) (x - mean_val)^2 * c * x^4, 0, 2)$value
      } else if (input$functionB == "fx2") {
        x <- seq(0, 1, length.out = 1000)
        b <- 3 * (1 - input$a / 2)
        mean_val <- integrate(function(x) x * (input$a * x + b * x^2), 0, 1)$value
        var_val <- integrate(function(x) (x - mean_val)^2 * (input$a * x + b * x^2), 0, 1)$value
      } else if (input$functionB == "fx3") {
        x <- seq(1, 100)
        f <- 4 / (x * (x + 1) * (x + 2))
        f <- f / sum(f)
        mean_val <- sum(x * f)
        var_val <- sum((x - mean_val)^2 * f)
      } else if (input$functionB == "fx4") {
        x <- seq(1, 9)
        f <- log(x / (x + 1))
        f <- f / sum(f)
        mean_val <- sum(x * f)
        var_val <- sum((x - mean_val)^2 * f)
      } else if (input$functionB == "fx5") {
        x <- seq(1, 10, length.out = 1000)
        density_function <- function(x, theta) {
          (theta^2 / (1 + theta)) * (1 + x) * exp(-theta * x)
        }
        norm_factor <- 1 / integrate(function(x) density_function(x, input$theta), 0, Inf)$value
        normalized_density <- function(x, theta) {
          density_function(x, theta) * norm_factor
        }
        mean_val <- integrate(function(x) x * normalized_density(x, input$theta), 0, Inf)$value
        var_val <- integrate(function(x) (x - mean_val)^2 * normalized_density(x, input$theta), 0, Inf)$value
      } else if (input$functionB == "fx6") {
        x <- seq(-5, 5, length.out = 1000)
        norm_factor <- 1 / sum(
            integrate(function(x) (1/3) * exp(x), -Inf, 0)$value,
            integrate(function(x) (1/3) * x^0, 0, 1)$value,
            integrate(function(x) (1/3) * exp(-(x - 1)), 1, Inf)$value
        )
        mean_val <- (
            integrate(function(x) x * (1/3) * exp(x) * norm_factor, -Inf, 0)$value +
            integrate(function(x) x * (1/3) * norm_factor, 0, 1)$value +
            integrate(function(x) x * (1/3) * exp(-(x - 1)) * norm_factor, 1, Inf)$value
        )
        mean_x2_val <- (
            integrate(function(x) x^2 * (1/3) * exp(x) * norm_factor, -Inf, 0)$value +
            integrate(function(x) x^2 * (1/3) * norm_factor, 0, 1)$value +
            integrate(function(x) x^2 * (1/3) * exp(-(x - 1)) * norm_factor, 1, Inf)$value
        )
        var_val <- mean_x2_val - (mean_val)^2
      } else if (input$functionB == "fx7") {
        mean_val <- "nedefinita (Cauchy)"
        var_val <- "nedefinita (Cauchy)"
      }
      # Afisarea mediei si variantei
      paste("Media: ", mean_val, "\nVarianta: ", var_val)
    })
  })
}

# Initializarea aplicatiei
shinyApp(ui = ui, server = server)
