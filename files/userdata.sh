#!/bin/bash

# Update and install httpd
dnf upgrade -y
dnf install -y httpd

cat <<EOF > /var/www/html/index.html 
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.0.13/css/all.css" integrity="sha384-DNOHZ68U8hZfKXOrtjWvjxusGo9WQnrNx2sqG0tfsghAvtVlRW3tvkXWZh58N9jp" crossorigin="anonymous">
  <!-- Bootstrap 4 -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">
  <!-- Bootstrap 4 Custom (local) -->
  <!-- <link rel="stylesheet" href="css/bootstrap.css"> -->
  
  <!-- Custom Style Sheet -->
  <link rel="stylesheet" href="css/style.css">
  <title>Multi Cloud</title>
</head>
<html>
<body>


  <body id="home" data-spy="scroll" data-target="#main-nav">
    <nav class="navbar navbar-expand-md navbar-light fixed-top py-4 bg-secondary " id="main-nav">
      <!-- <nav class="navbar navbar-expand-md navbar-light fixed-top py-4" id="main-nav"></nav> -->
      <!-- bg-secondary text-white -->
      <div class="container ">
        <a href="#home" class="navbar-brand">
          <img src="https://upload.wikimedia.org/wikipedia/commons/archive/5/5c/20191001220559%21AWS_Simple_Icons_AWS_Cloud.svg" width="50" height="50" alt="">
          <h3 class="d-inline align-middle text-white">This Web Page is running on AWS</h3>
        </a>
        <button class="navbar-toggler" data-toggle="collapse" data-target="#navbarCollapse">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarCollapse">
          <ul class="navbar-nav ml-auto ">
            <li class="nav-item ">
              <a href="#home" class="nav-link">Home</a>
            </li>
            <li class="nav-item">
              <a href="#training" class="nav-link">Architecture</a>
            </li>
          </ul>
        </div>
      </div>
    </nav>

    <section  id="showcase" class="py-5">
      <div class="primary-overlay text-white bg-secondary ">
        <div class="container">
          <div class="row">
            <div class="col-lg-6 text-center">
              <h1 class="display-2 mt-5 pt-5">
                
              </h1>
              <p class="lead"></p>
              <!-- <a href="#" class="btn btn-outline-secondary btn-lg text-white">
                <i class="fas fa-arrow-right"></i> Read More
              </a> -->
            </div>
            <!-- <div class="col-lg-6">
              <img src="https://cloudhacks-public-html-file.s3.amazonaws.com/images/tf_aws.jpeg" alt="" class="img-fluid d-none d-lg-block">
            </div> -->
          </div>
        </div>
      </div>
    </section>

        <!-- TRAINING / WHY SECTION -->
        <section id="architecture" class="py-5 text-left bg-light">
          <div class="container">
            <div class="row">
              <div class="col">
                <div class="info-header mb-5">
                  <h1 class="text-secondary pb-3">
                    Cloud Architecture
                  </h1>
                  <p class="lead pb-3">
                    This architecture is a simple example of a web application running on AWS. It is designed to be highly available and scalable and is deployed across multiple Availability Zones to ensure that the application is fault tolerant. An Application Load Balancer to distribute traffic across multiple EC2 instances. The architecture also uses an Auto Scaling Group to automatically scale the number of EC2 instances based on traffic load. Finally, Route 53 is used to route traffic to the Application Load Balancer. 
                    <img  src="https://cloudhacks-public-html-file.s3.amazonaws.com/images/tf_aws.jpeg" alt="AWS Architecture"> 
                  </p>
                </div>
              </div>
            </section>      

<!-- <h1>AWS</h2>
<p><em>This Web Page is running on AWS</em></p>
<p><em>The server name is aws-asg</em></p> -->

<!-- UNCOMMENT FOR AWS -->

<!-- <img  src="https://upload.wikimedia.org/wikipedia/commons/archive/5/5c/20191001220559%21AWS_Simple_Icons_AWS_Cloud.svg" alt="AWS" style="width:616px;height:768px;"> 
<h2> Web Application Architecture on AWS </h2>
<img  src="https://cloudhacks-public-html-file.s3.amazonaws.com/images/tf_aws.jpeg" alt="AWS Architecture">  -->



    <!-- FOOTER -->
    <footer id="main-footer" class="py-2 bg-secondary text-white">
      <div class="container">
        <div class="row text-center">
          <div class="col-md-6 ml-auto">
            <p class="lead">
              Copyright &copy;
              <span id="year">2024</span>
              <span id="author"> -- Created by Al not AI</span>
            </p>
          </div>
        </div>
      </div>
    </footer>

</body>


  <!-- End Content Here -->

  <!-- Choose Jquery version -->
  <!-- <script src="https://cdn.jsdelivr.net/npm/jquery@3.5.1/dist/jquery.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script> -->
  <script 
    src="https://code.jquery.com/jquery-3.7.1.min.js" 
    integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" 
    crossorigin="anonymous">
  </script>
  <script 
    src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" 
    integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" 
    crossorigin="anonymous">
  </script>
  <script 
    src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.min.js" 
    integrity="sha384-+sLIOodYLS7CIrQpBjl+C7nPvqq+FbNUBDunl/OZv93DB7Ln/533i8e/mZXLi/P+" 
    crossorigin="anonymous">
  </script>
  
<script>
    // Get the current year for the copyright
    // Use example = <span id="year"></span>
    
    $('#year').text(new Date().getFullYear);

  // Init Scrollspy
  $('body').scrollspy({ target: '#main-nav' });

  // Smooth Scrolling
  $("#main-nav a").on('click', function (event) {
    if (this.hash !== "") {
      event.preventDefault();

      const hash = this.hash;

      $('html, body').animate({
        scrollTop: $(hash).offset().top
      }, 800, function () {

        window.location.hash = hash;
      });
    }
  });
</script>

</html>
EOF

systemctl start httpd
systemctl enable httpd
systemctl is-enabled httpd