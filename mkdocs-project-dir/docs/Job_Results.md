# Where do my results go?

After submitting your job you can use the command 'qstat' to view the status of the job you have submitted. Once you can no longer see your job on the qstat list this means your job has completed to view the jobs that have completed you can run 'jobhist'. There are various ways of monitoring the output of your job.

## Output and error files
When writing up your job script you specifiy your working directory, within this working directory you can find your output(.o) and error(.e) files. These files will contain any possible error your jobs may have come across or any output that was excepted from your job.

## Grid engine mailing system
The following options can be used to submit and monitor a job<br />
###Qsub <br />
####Qstat <br /> 
###Qdel <br />

## Qsub emailing
We also have a mailing system that can be implemented to send emails with reminders of the status of your job through qsub. When you use qsub to submit your job you can use the option `-m`. You can specify when you want an email sent to you by using the below options after `qsub -m`:
<br /><br />
b-Mail is sent at the beginning of the job. <br />
e-Mail is sent at the end of the job. <br />
a-Mail is sent when the job is aborted or rescheduled. <br />
s-Mail is sent when the job is suspended. <br />
n-No mail is sent. <br />


