getwd()

setwd("/Users/Cipher/Documents")

#View(head(dataset1,10))
#View(stim_i)
#unique(stim_i)
#c(1,7:9)
#class(stim_i)
#nrow(dataset1)

# This R module splits the data and take the first 3/4 of the stimulus presentation cycles 
# in the training data as the training data. We cannot use the regular data split module
# since we have split by stimulus presentation cycles.

# function fh_get_events get() the event start timestamp (col1), event midway timestamp (col2), and event type (0, 1, or 2) from a stimulus column. 
# The original stimulus column has 1 observation per millisecond. 
# event midway=(current event start timestamp + next event start time stamp)/2.
# event type 0 means it is inter-stimulus interval starting time,
# event type 1 means it is the onset time of the house stimulus, 
# event type 2 means it is the onset time of the face stimulus
fh_get_events = function(stim)  {
  nrows <- nrow(stim)
  if (stim[nrows] != 0 & stim_i[nrows] != 101){ #if the last stimulus type is not 0 or 101, 
    #meaning that the stim column ends at the end of a house or a face stimulus presentation cycle. 
    #Padding a 0 after that, otherwise, the last stimulus onset event will not be recoganized. 
    stim <- rbind(stim_i,0)
  }
  tmp=c(0,stim[1:((length(stim)-1))])
  b <- which((stim-tmp)!=0 )  #Get the stimulus type changing time
  c <- floor(diff(b)/2)       #Get the half of the times between two consecutive events
  b<-b[1:length(b)-1]  
  d <- b + c  # Get the midway between two consecutive events
  evs=matrix(data=NA, nrow=length(b),ncol=3)
  evs[ ,1] <- b 
  evs[ ,2] <- d 
  evs[ ,3] <- stim_i[d] 
  evs<-evs[which( evs[ ,3] != 0 ), ] # If stimulus type is 0, it is not ISI, nor stimulus presentation time. Get rid of these events
  evs[which( evs[ ,3] < 51 ),3] <- 1 # Stimulus types 1 - 50 means it is house stimulus (stimulus class 1)
  evs[which( evs[ ,3] == 101 ),3] <- 0 # If original stimulus type is 101, meaning that it is ISI, relabel it as event 0
  evs[which( evs[ ,3] > 50 ),3] <- 2 # Stimulus types 51 - 100 means it is face stimulus (stimulus class 2)
  rm(b,c,d) 
  return(evs)
} 

dataset1 <- read.csv("ecog_train_with_labels.csv") # get data  # class: data.frame
col_names <- colnames(dataset1)
training_portion <- 3/4 # Taking the first 75% stimulus presentation cycles as the training data, for each patient
unique_patients <- unique(dataset1[,1]) # get the list of unique patient ID
num_patients <- length(unique_patients) # get the number of unique patients
num_cols <- ncol(dataset1)
data.set <- NULL
for (i in 1:num_patients){
  data_i <- dataset1[dataset1[,1]==unique_patients[i],] #get the data of a patient
  num_cols_i <- sum(data_i[1,] != -999999) # get the number of columns that are not valued -999999, which indicates that this column does not have signals. 
  signal_i <- data_i[,2:(num_cols_i-2)] # get the signals from valid channels for this patient.
  stim_i <- as.matrix(data_i[,(num_cols-1)]) # get the stimulus column of this patient, and convert it to matrix, which is required by function fh_get_events()
  
  ## create events vector. It returns two columns: col1: stimulus start time, col2: stimulus type 1 for house, 2 for face
  events_i=fh_get_events(stim_i); #get the events for this patient
  events_12_i= events_i[which(events_i[,3]!=0),] # only need the stimulus onset time
  events_12_i=events_12_i[,-2]
  num_stimulus_train <- floor(nrow(events_12_i)*training_portion) #number of events to be put in the training data
  train_last_time <- events_12_i[num_stimulus_train,1] + 399 #the last record in the training data should be the stimulus onset time of the last stimulus presentation cycle + 399 milliseconds
  data.set <- rbind(data.set, data_i[1:train_last_time,]) #add the training records of this patient to data.set
}

data.set <- as.data.frame(data.set) #convert it to a data frame to be output from this R module
colnames(data.set) <- col_names

# Select data.frame to be sent to the output Dataset port
#maml.mapOutputPort("data.set");