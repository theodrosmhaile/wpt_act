# Weather Prediction Task ACT-R models

## These are a series of models that learn the weather prediction task. 

The weather prediction task in these models are based on the Li et al. 2016 paper -  *Paired associate and Feedback-Based Weather Prediction Tasks Support Multiple Category learning Systems*.

---

### RL-Only model: RL_model_wpt.lisp

This model contains productions for all card presentations, including single card, 2-card and 3-card presentations. The probabilities are learned by individual productions for each combination of those card presentations. 

#### To run the model:-

 Use  *RL_WPT_interface.py* to test the model. simply load the script by running e.g. `import RL_wpt_interface as rl`. 
 The script contains a handy function for running a simulation which required 3 inputs,  `rl.simmulation(alpha, egs, nSims)`, where `alpha` is RL learning rate, `egs` is RL noise, and `nSims` is the number of simulations you would like. 
 Data is saved to a `sim_data` variable which is a pandas DataFrame that contains the accuracy for each of the card combinations (of which there are 14, see Li et al. 2016). The `test_wpt_interface.ipynb` Jupyter notebook might be a nice place to play with the models. 
 
--- 

### LTM-Only model : LTM_model_wpt.lisp 

This model is an adaptation of the RLWM LTM model. It simply checks memory whenever a stimulus is presented. If the current stimulus and a response isn't found in declarative memory it responds

#### To run the model:-

 Use  *LTM_WPT_interface.py* to test the model. simply load the script by running e.g. `import LTM_wpt_interface as ltm`. 
 The script contains a handy function for running a simulation which required 4 inputs,  `ltm.simmulation(bll, imag, ans, nSims)`, where `bll` is decay rate of declarative memory, `imag` is imaginal activation, `ans` is activation noise and `nSims` is the number of simulations you would like. 
 Data is saved to a `sim_data` variable which is a pandas DataFrame that contains the accuracy for each of the card combinations (of which there are 14, see Li et al. 2016). The `test_wpt_interface.ipynb` Jupyter notebook might be a nice place to play with the models. 
