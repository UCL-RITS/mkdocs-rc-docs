# Giving Files to Another User

This is a walkthrough for when:

 - you need to give someone a file
 - they're working on the same cluster as you

We have a tool installed called "pipe-gifts" for handling this, that works quickly even for large files.

## The Sender

1. Log in to one of the cluster login nodes.
2. `cd` to where the files you want to transfer are.
3. Load the "pipe-gifts" module:

```
$ module load pipe-gifts
```

4. Use `pipe-give` with the name of one or more files, to set up the transfer.

For example, here we're transferring a file called `some_file`:

```
$ pipe-give some_file

Your transfer ID: dzbGPpE3
    and password: 688815576

Please enter this at receiver.

Remember you must be on the same node.

This node is: login01

    [Ctrl-C to cancel.]
```

5. Give the login node name (`login01` here), transfer ID, and password to the person you want to receive the files. The password only applies to this single transfer, so it's fine to send it via email or an IM system.

6. Wait for the receiver to accept the transfer, and `pipe-give` to report that the transfer is complete.

You should see something like this:

```
[2020-12-02 15:06:44] pipe-give: (info) received correct password
[2020-12-02 15:06:44] pipe-give: (info) sending identity and number of files
[2020-12-02 15:06:44] pipe-give: (info) sending file listing to receiver for approval
[2020-12-02 15:06:55] pipe-give: (info) confirmation received
[2020-12-02 15:06:55] pipe-give: (info) transferring files...
some_file
1.00GiB 0:00:04 [ 234MiB/s] [                        <=>                                                                                                                                                                                                                                ]
[2020-12-02 15:06:59] pipe-give: (info) transfer complete
```


## The Receiver

1. Log in to the cluster.
2. Get the login node name, transfer ID, and password from the person sending you the files.
3. Make sure you're logged in to the same node as the sender. If you aren't, use `ssh` to connect to the right one.

For example, here we're logged into login01:

```
[ccaa002@login01 ~]$
```

But our friend tells us they're on login02, so we connect to that one instead:

```
[ccaa002@login01 ~]$ ssh login02
Last login: Wed Dec 20 17:47:18 2023 from 10.36.142.98
[intro message]

[ccaa002@login02 ~]$ 
```

4. Load the "pipe-gifts" module:

```
$ module load pipe-gifts
```

5. (Optional) Use `cd` to change directory to where you want to receive the files to, for example:

```
$ cd files_from_my_friend
```

6. Use `pipe-receive` to set up the transfer. Enter the ID and password when requested, check the list of files that are going to be sent, and wait for the transfer to complete.

You should see something like this:

```
$ pipe-receive
Please enter your transfer ID: dzbGPpE3
Please enter transfer password: 688815576
[2020-12-02 15:06:44] pipe-receive: (info) password correct, receiving identity and file count
[2020-12-02 15:06:44] pipe-receive: (info) receiving list of files for approval

-- File List --
some_file
---------------

User ccaa001 wants to copy this file to you.
Would you like to accept? [press y for yes, anything else to cancel]
[2020-12-02 15:06:55] pipe-receive: (info) confirming with sender
[2020-12-02 15:06:55] pipe-receive: (info) receiving files...
some_file
1.00GiB 0:00:04 [ 234MiB/s] [                        <=>                                                                                                                                                                                                                                ]
[2020-12-02 15:06:59] pipe-receive: (info) transfer complete
```
