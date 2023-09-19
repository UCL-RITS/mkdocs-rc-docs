---
title: UCL Service For Me
layout: docs
---

# Which service(s) at UCL are right for me?

Depending on the type of jobs you would like to run each cluster can have different requirements that your jobs must meet. When you submit your [user account application form](Account_Services.md) you will be given access to the cluster depending on resources selected.

Currently we categorise intended workloads into ones that use:

 - Individual single core jobs
 - Large numbers (>1000) of single core jobs
 - Multithreaded jobs
 - Extremely large quantities of RAM (>64GB)
 - Small MPI jobs (<32 cores)
 - Medium-sized MPI jobs (32-256 cores)
 - Large-sized MPI jobs (>256 cores)
 - At least one GPGPU
 - At least ten GPGPUs
    
Each cluster has its own specifications for the types of jobs that they run which is all dependable on list above. The cluster machines we have available are:

- Myriad

Myriad is designed to be most suitable for serial work, including large numbers of serial jobs, and multi-threaded jobs (using e.g. OpenMP). It also includes a small number of GPUs for development or testing work. It went into service in July 2018. See [Myriad](Clusters/Myriad.md).

- Kathleen
 
Kathleen is intended for multi-node jobs (using e.g. MPI) and went into service in Feb 2020 as a replacement for Grace. We recommend using Kathleen if you intend to use more than 36 cores per job. See [Kathleen](Clusters/Kathleen.md).

- Young

Young is the UK's Tier 2 Materials and Molecular Modelling Hub, and replacement for [Thomas](Clusters/Thomas.md). It is accessible by members of partner institutions and relevant consortia, and is for materials and molecular modelling work only. It has separate access procedures from UCL's central clusters. Access is managed by a Point of Contact from the relevant institution or consortia, not by Research Computing. See [Young](Clusters/Young.md).

- Michael

Michael is an extension to the UCL-hosted Hub for Materials and Molecular Modelling, an EPSRC-funded Tier 2 system providing large scale computation to UK researchers; and delivers computational capability for the Faraday Institution, a national institute for electrochemical energy storage science and technology. Access is managed by a Point of Contact from the Faraday Institution, not by Research Computing. See [Michael](Clusters/Michael.md).


