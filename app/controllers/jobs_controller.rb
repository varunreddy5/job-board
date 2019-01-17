class JobsController < ApplicationController
  # before_action :select_job, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def new
    @job = current_user.jobs.build
  end

  def create
    @job = current_user.jobs.build(job_params)
    token  = params[:stripeToken]
    job_type = params[:job_type]
    job_title = params[:title]
    card_brand = params[:user][:card_brand]
    card_exp_month = params[:user][:card_exp_month]
    card_exp_year = params[:user][:card_exp_year]
    card_last4 = params[:user][:card_last4]
    charge = Stripe::Charge.create(
      :amount => 300,
      :currency => "usd",
      :description => job_type,
      :statement_descriptor => job_title,
      :source => token
    )
    current_user.stripe_id = charge.id
    current_user.card_brand = card_brand
    current_user.card_exp_month = card_exp_month
    current_user.card_exp_year = card_exp_year
    current_user.card_last4 = card_last4
    current_user.save!
    if @job.save
      redirect_to(jobs_path)
    else
      render('new')
    end
  end

  def index
    @jobs = Job.order("created_at desc")
    @filter_jobs = Job.all.map{ |job| [job.title, job.id]}
  end

  def show
  end

  def edit
    @job = Job.find(params[:id])
  end

  def update
    @job = Job.find(params[:id])
    if @job.update_attributes(job_params)
      redirect_to(jobs_path)
    else
      render('edit')
    end
  end

  def delete
  end

  private
  def job_params
    params.require(:job).permit(:title, :description, :url, :job_type, :location, :job_author, :remote_ok, :apply_url, :avatar)
  end
end
