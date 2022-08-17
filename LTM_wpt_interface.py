#!/usr/bin/env python
# coding: utf-8

# ### Python interface for integrated model


import random as rnd
import numpy as np
import os
import sys
import string
import actr
import pandas as pd
import seaborn as sns 
from matplotlib import pyplot
import itertools


show_output = False

#Load model
curr_dir = os.path.dirname(os.path.realpath(__file__))
actr.load_act_r_model(os.path.join(curr_dir, "LTM_model_wpt.lisp")) #integrated-model-pipe.lisp

## Daisy chained python functions to present stimuli, get response and  present feedback

def present_stim():
    global chunks
    global i
    global show_output

    if i < nTrials:
        
        # set up stimuli
        stim_temp = np.sort(np.array([stim_names.loc[stim_lineup.loc[i,'id'] - 1].dropna(how='all')])).flatten()
        stim = np.append(stim_temp, ['nil', 'nil'])
        # present stimuli
        chunks = actr.define_chunks(['isa', 'stimulus', 'card1', stim[0], 'card2', stim[1], 'card3', stim[2]])
        actr.set_buffer_chunk('visual', chunks[0])
        
        if(show_output):
            print('Presented: ', stim)
            print('correct response: ', cor_resps[i])   

    
def get_response(model, key):
    global current_response
    global i
    global strategy_used

    
    actr.schedule_event_relative(0, 'present_feedback')
    current_response[i] = key 
    #print('response')
    return current_response


def present_feedback():
    global i
    global current_response
    global accuracy


    # This portion presents feedback
    feedback = 'no'
        
    # check if response matches the appropriate key for the current stimulus in cue
    if current_response[i] == cor_resps[i]:
        feedback = 'yes'
        accuracy[i] = 1
# present feedback    
    chunks = actr.define_chunks(['isa', 'feedback', 'feedback',feedback])
    actr.set_buffer_chunk('visual', chunks[0])

    if (show_output):
        print("Feedback given: ", feedback )
        print(accuracy)

   
    actr.schedule_event_relative(1, 'present_stim')
#increase index for next stimulus
    i = i + 1
    
   

# This function builds ACT-R representations of the python functions

def model_loop():
    
    global win
    global accuracy
    global nTrials
    global strategy_used
    
    accuracy = np.repeat(0, nTrials).tolist()
   


   
    
    #initial goal dm
    actr.define_chunks(['make-response','isa', 'goal', 'fproc','yes'])  
  #  actr.add_dm(['test-feedback', 'isa', 'feedback', 'feedback', 'yes'])
    
  #  actr.add_dm('yes'); actr.add_dm('no') 
    
   # actr.add_dm('declarative'); actr.add_dm('procedural')
    
   # actr.add_dm('j'); actr.add_dm('k'); actr.add_dm('l')

    #actr.add_dm('jeans'); actr.add_dm('cup'); actr.add_dm('hat'); 
    #actr.add_dm('shirt'); actr.add_dm('plate'); actr.add_dm('gloves')
    #actr.add_dm('shoes'); actr.add_dm('bowl'); actr.add_dm('jacket')

    actr.goal_focus('make-response')    
    
    #open window for interaction
    win = actr.open_exp_window("test", visible = False)
    actr.install_device(win)
    actr.schedule_event_relative(0, 'present_stim' )
   
    #waits for a key press?
   
    actr.run(2000)
    
    #print(accuracy)

actr.add_command('present_stim', present_stim, 'presents stimulus') 
actr.add_command('present_feedback', present_feedback, 'presents feedback')
actr.add_command('get_response', get_response, 'gets response')
actr.monitor_command("output-key", 'get_response')

## execute model and simulate data

#Stimuli to be used and exp parameters
stim_lineup=pd.read_csv('./WPT_task/complete_trial_wpt.csv')

stim_names = pd.DataFrame({1:['square','square','square','square','square','square','square',
                                np.nan,np.nan,np.nan,np.nan,np.nan,np.nan,np.nan],
                           2:['diamond','diamond','diamond',np.nan,np.nan,np.nan,np.nan,
                              'diamond','diamond','diamond','diamond',np.nan,np.nan,np.nan],
                          3:['circle',np.nan,np.nan,'circle','circle',np.nan,np.nan,'circle','circle',
                            np.nan,np.nan,'circle','circle',np.nan],
                          4:[np.nan, 'triangle',np.nan,'triangle',np.nan,'triangle',np.nan,'triangle',np.nan,'triangle',np.nan,
                            'triangle',np.nan, 'triangle']}
                                        )

#variables needed

nTrials = 200
chunks = None
current_response  = np.repeat('x', nTrials).tolist()
accuracy = np.repeat(0, nTrials).tolist()
# concat all stimuli and responses together to present

cor_resps = np.where(stim_lineup['sun']==1, 's','r') # assign s for 'sun' and r for 'rain' responses



#parameter ranges for simulation
bll_param   = [0.3, 0.4, 0.5, 0.6, 0.7]   # decay rate of declarative memory,range around .5 actr rec val
imag_param  = [0.1, 0.2, 0.3 , 0.4, 0.5] #simulates working memory as attentional focus 
ans_param   = [0.1, 0.2, 0.3, 0.4, 0.5] #parameter for noise in dec. memory activation. Range recommended by ACTR manual.

#Integrated model params

#RL model params
#params = [alpha_param, egs_param]
#param_combs = list(itertools.product(*params))

# LTM model params
params = [bll_param, imag_param, ans_param]
param_combs = list(itertools.product(*params))

 ###########initialize variables to concat all outputs from simulations

sim_data = pd.DataFrame()

I_data = []
#i=0



def simulation(bll, imag, ans, nSims):
   
    global i
    global learn_temp
    global sim_data
   
    global accuracy
    
    
    print('vars reset')
    temp3 = [] 
    temp6 = []
    temp_test3 = []
    temp_test6 = []
    #accuracy = np.repeat(0, nTrials).tolist()
    nsimulations = np.arange(nSims) #set the number of simulations "subjects"
    
    for n in nsimulations:
        print("sim ", n)
        actr.reset()
       # actr.hide_output()

        actr.set_parameter_value(":bll", bll)
        actr.set_parameter_value(":visual-activation", imag)#formerly imaginal activation
        actr.set_parameter_value(":ans", ans)
       
        
        i = 0
        win = None
        print(i)
        model_loop()

       
       ### Analyze generated data: LEARNING
            
        learn_temp = pd.DataFrame({'acc': accuracy, 'index': stim_lineup.loc[:,'id'], 'bll': bll,'imag': imag, 'ans': ans})
        sim_data = sim_data.append(learn_temp)
    

       

       
def execute_sim(n,fromI,toI, frac):
    global sim_data
    for i in range(fromI, toI):

        simulation(param_combs[i][0], param_combs[i][1], param_combs[i][2], n)
      
    sim_data.to_csv('./simulated_data/LTM_model/LTM_wpt_sim_data_' + 'frac_' +np.str(frac) +'_'+ np.str(fromI) + '_to_' + np.str(toI))

